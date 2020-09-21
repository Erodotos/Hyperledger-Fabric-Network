package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	pb "github.com/hyperledger/fabric-protos-go/peer"
)

// To store the data in the ledger
type TelcoEntry struct {
	Counter   int     `json:"counter"`   //col 2
	CellName  string  `json:"cell_name"` //col 5
	Value     float32 `json:"value"`     //col 6
	Timestamp int64   `json:"timestamp"` //col 7, e.g. '201512200045' -> '%Y%m%d%H%M', this format can be used with numeric comparisons
}

// To add helpful information to the data
type TelcoData struct {
	MeasInfo     string       `json:"meas_info"` //col 1
	MinTimestamp int64        `json:"min_timestamp"`
	MaxTimestamp int64        `json:"max_timestamp"`
	Batch        []TelcoEntry `json:"batch"`
}

// ===================================================================================
// Main
// ===================================================================================
func main() {
	err := shim.Start(new(TelcoData))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}

// Init initializes chaincode
// ===========================
func (t *TelcoData) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

// Invoke - Our entry point for Invocations
// ========================================
func (t *TelcoData) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	function, args := stub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)

	// Handle different functions
	if function == "WriteBatch" {
		return t.WriteBatch(stub, args)
	} else if function == "QueryBatchRangeWithPagination" {
		return t.QueryBatchRangeWithPagination(stub, args)
	}

	fmt.Println("invoke did not find func: " + function) //error
	return shim.Error("Received unknown function invocation")
}

// Writes the received data batch in the ledger.
// The data in the batch must refer to the "meas_info".
// Arguments:
// 		args[0] -> a JSON with the data; must be in the form of a TelcoEntry struct.
//		args[1] -> the "meas_info" of the received data
//	 	args[2] -> the timestamp on which the chaincode API was invoked
// JSON string/args[0] example:
//[
//	{
//		"counter":50331654,
//		"cell_name":"8424bf520db261335d52a0b827a78538",
//		"value":4863,
//		"timestamp":201512200045
//	},
//	{
//		"counter":50331655,
//		"cell_name":"8424bf520db261335d52a0b827a78538",
//		"value":268,
//		"timestamp":201512200045
//	}
//]
func (t *TelcoData) WriteBatch(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	// Cast the data into the desired format
	var batch TelcoData
	err := json.Unmarshal([]byte(args[0]), &batch.Batch)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Add their "meas_info" information
	batch.MeasInfo = args[1]

	// Cast the struct in []byte format
	batchBytes, err := json.Marshal(batch)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Save the batch to world state.
	err = stub.PutState(args[1]+`_`+args[2], batchBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(batchBytes)
}

/*
// Retrieves the data_batches that contain entries of interest; may return more data than requested.
//
// PENDING: Drop the unnecessary data
//
// Uses couchDB's $elemMatch much queries to retrieve the ledger entries of interest.
func (t *TelcoData) QueryRangeWithPagination(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	return shim.Success([]byte{0x00})
}
*/

// =========================================================================================
// QueryBatchRangeWithPagination executes the passed in query string with
// pagination info. Result set is built and returned as a byte array containing the JSON results.
// =========================================================================================
func (t *TelcoData) QueryBatchRangeWithPagination(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	// "queryString"
	if len(args) < 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	queryString := args[0]
	//return type of ParseInt is int64... but we need int32
	pageSize, err := strconv.ParseInt(args[1], 10, 32)
	if err != nil {
		return shim.Error(err.Error())
	}
	bookmark := args[2]

	fmt.Printf("- QueryBatchRangeWithPagination queryString:\n%s\n", queryString)

	resultsIterator, responseMetadata, err := stub.GetQueryResultWithPagination(queryString, int32(pageSize), bookmark)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	buffer, err := constructQueryResponseFromIterator(resultsIterator)
	if err != nil {
		return shim.Error(err.Error())
	}

	bufferWithPaginationInfo := addPaginationMetadataToQueryResults(buffer, responseMetadata)

	fmt.Printf("- getQueryResultForQueryString queryResult:\n%s\n", bufferWithPaginationInfo.String())

	return shim.Success(buffer.Bytes())
}

// ===========================================================================================
// constructQueryResponseFromIterator constructs a JSON array containing query results from
// a given result iterator
// ===========================================================================================
func constructQueryResponseFromIterator(resultsIterator shim.StateQueryIteratorInterface) (*bytes.Buffer, error) {
	// buffer is a JSON array containing QueryResults
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"Key\":")
		buffer.WriteString("\"")
		buffer.WriteString(queryResponse.Key)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Record\":")
		// Record is a JSON object, so we write as-is
		buffer.WriteString(string(queryResponse.Value))
		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	return &buffer, nil
}

// ===========================================================================================
// addPaginationMetadataToQueryResults adds QueryResponseMetadata, which contains pagination
// info, to the constructed query results
// ===========================================================================================
func addPaginationMetadataToQueryResults(buffer *bytes.Buffer, responseMetadata *pb.QueryResponseMetadata) *bytes.Buffer {

	buffer.WriteString("[{\"ResponseMetadata\":{\"RecordsCount\":")
	buffer.WriteString("\"")
	buffer.WriteString(fmt.Sprintf("%v", responseMetadata.FetchedRecordsCount))
	buffer.WriteString("\"")
	buffer.WriteString(", \"Bookmark\":")
	buffer.WriteString("\"")
	buffer.WriteString(responseMetadata.Bookmark)
	buffer.WriteString("\"}}]")

	return buffer
}
