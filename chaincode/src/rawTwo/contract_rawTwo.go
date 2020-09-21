package main

import (
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
	MeasInfo string       `json:"meas_info"` //col 1
	Batch    []TelcoEntry `json:"batch"`
}

// =========
// Main
// =========
func main() {
	err := shim.Start(new(TelcoData))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}

// ===========================
// Init initializes chaincode
// ===========================
func (t *TelcoData) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

// ========================================
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

// ===========================================================================================
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
// ===========================================================================================
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

// Retrieves the data_batches that contain entries of interest; may return more data than requested.
//
// PENDING: Drop the unnecessary data
//
// Uses couchDB's $elemMatch much queries to retrieve the ledger entries of interest.
func (t *TelcoData) QueryRangeWithPagination(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	return shim.Success([]byte{0x00})
}

// =======================================================================================================
// QueryBatchRangeWithPagination executes the passed in query string with
// pagination info. Result set is built and returned as a TelcoEntry array containing the results.
//
// NOTE: The queryString can be use to retrieve any combination of meas_info(s) and couter(s).
// 		 The fromTimestamp and toTimestamp are used to bound the results returned, and cannot be ommited.
//
// EXAMPLE queryString: "{"selector":{"$and":[{"meas_info":"dummy_meas_info"},{"batch":{"$elemMatch":{"counter":{"$and":[{"$gt":5},{"$lt":99999999}]}}}}]}}"
//
// PENDING: Currently only returns the 1st page of results. Must implement a while-loop to use
//		the bookmark to retrieve all of them.
//
// ========================================================================================================
func (t *TelcoData) QueryBatchRangeWithPagination(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	//arg[0]=queryString -> to declare meas_info, counter selector
	//arg[1]=pageSize
	//arg[2]=bookmark
	//arg[3]=fromTimestamp -> to declare the time interval
	//arg[4]=toTimestamp

	// Cast accordingly
	queryString := args[0]
	//return type of ParseInt is int64... but we need int32
	pageSize, err := strconv.ParseInt(args[1], 10, 32)
	if err != nil {
		return shim.Error(err.Error())
	}
	bookmark := args[2]
	fromTimestamp, err := strconv.ParseInt(args[3], 10, 64)
	if err != nil {
		return shim.Error(err.Error())
	}
	toTimestamp, err := strconv.ParseInt(args[4], 10, 64)
	if err != nil {
		return shim.Error(err.Error())
	}

	resultsIterator, responseMetadata, err := stub.GetQueryResultWithPagination(queryString, int32(pageSize), bookmark)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	entries, bookmark, err := constructQueryResponseFromIterator(resultsIterator, responseMetadata, fromTimestamp, toTimestamp)
	if err != nil {
		return shim.Error(err.Error())
	}

	entriesBytes, err := json.Marshal(entries)
	if err != nil {
		return shim.Error("Marshal failed!")
	}

	return shim.Success(entriesBytes)
}

// ================================================================================================
// constructQueryResponseFromIterator constructs an array containing query results of interest from
// a given result iterator
// ================================================================================================
func constructQueryResponseFromIterator(resultsIterator shim.StateQueryIteratorInterface, responseMetadata *pb.QueryResponseMetadata, fromTimestamp, toTimestamp int64) (*[]TelcoEntry, string, error) {

	// Declare TelcoEntry collector
	var entries []TelcoEntry

	// Get the query results
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, "", err
		}

		// Get the retrieved record
		var teldata TelcoData
		err = json.Unmarshal(queryResponse.Value, &teldata)
		if err != nil {
			return nil, "", err
		}

		// Iterate over returned entries
		for _, b := range teldata.Batch {
			if b.Timestamp >= fromTimestamp && b.Timestamp < toTimestamp {
				entries = append(entries, b)
			}
		}

	}

	return &entries, responseMetadata.Bookmark, nil
}
