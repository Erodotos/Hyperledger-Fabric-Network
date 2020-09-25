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
	Value     float32 `json:"value"`     //col 6
	Timestamp int64   `json:"timestamp"` //col 7, e.g. '201512200045' -> '%Y%m%d%H%M', this format can be used with numeric comparisons
}

// To add helpful information to the data
type TelcoData struct {
	Batch []TelcoEntry `json:"batch"`
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
	} else if function == "WriteBatch2" {
		return t.WriteBatch2(stub, args)
	} else if function == "QueryBatchRange2" {
		return t.QueryBatchRange2(stub, args)
	} else if function == "WriteBatchComposite" {
		return t.WriteBatchComposite(stub, args)
	} else if function == "QueryBatchRangeComposite" {
		return t.QueryBatchRangeComposite(stub, args)
	}

	fmt.Println("invoke did not find func: " + function) //error
	return shim.Error("Received unknown function invocation")
}

// ===========================================================================================
// Writes the received data batch in the ledger.
// The data in the batch must refer to the same "meas_info" and "counter".
// Arguments:
// 		args[0] -> a JSON with the data; must be in the form of a TelcoEntry struct.
//		args[1] -> the "meas_info" of the received data
//		args[2] -> the "counter" of the received data
//	 	args[3] -> the timestamp on which the chaincode API was invoked OR the minimum timestamp in the batch
// JSON string/args[0] example:
//[
//	{
//		"value":4863,
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

	// Cast the struct in []byte format
	batchBytes, err := json.Marshal(batch)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Save the batch to world state.
	err = stub.PutState(args[1]+`_`+args[2]+`_`+args[3], batchBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(batchBytes)
}

// =======================================================================================================
// QueryBatchRangeWithPagination executes the passed in query string with
// pagination info. Result set is built and returned as a TelcoEntry array containing the results.
//
// NOTE: (1) The queryString can be used to retrieve any set of ledger entries, on which the measurements will
//		     be extracted from according to the time-bounds provided.
// 		 (2) The fromTimestamp and toTimestamp are used to bound the results returned, and cannot be ommited.
//		 (3) The data entries in a single data batch have the same "meas_info" and "counter".
//
// EXAMPLE queryString: "{\"selector\":{\"_id\":{\"$regex\":\"^test_meas_info_counter1\"}}}"
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

	var entries []TelcoEntry
	loop := true

	for loop {
		resultsIterator, responseMetadata, err := stub.GetQueryResultWithPagination(queryString, int32(pageSize), bookmark)
		if err != nil {
			return shim.Error(err.Error())
		}
		defer resultsIterator.Close()

		entries, err = constructQueryResponseFromIterator(resultsIterator, fromTimestamp, toTimestamp, entries)
		if err != nil {
			return shim.Error(err.Error())
		}

		if responseMetadata.FetchedRecordsCount == 0 {
			loop = false
		}
		bookmark = responseMetadata.Bookmark
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
func constructQueryResponseFromIterator(resultsIterator shim.StateQueryIteratorInterface, fromTimestamp, toTimestamp int64, entries []TelcoEntry) ([]TelcoEntry, error) {

	// Get the query results
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		// Get the retrieved record
		var teldata TelcoData
		err = json.Unmarshal(queryResponse.Value, &teldata)
		if err != nil {
			return nil, err
		}

		// Iterate over returned entries
		for _, b := range teldata.Batch {
			if b.Timestamp >= fromTimestamp && b.Timestamp < toTimestamp {
				entries = append(entries, b)
			}
		}

	}

	return entries, nil
}

// ===========================================================================================
// Writes the received data batch in the ledger.
// Arguments:
// 		args[0] -> a JSON with the data; must be in the form of a TelcoEntry struct.
//		args[1] -> the "meas_info" of the received data
//		args[2] -> the "counter" of the received data
//	 	args[3] -> minimum timestamp in batch
// JSON string/args[0] example:
//[
//	{
//		"value":4863,
//		"timestamp":201512200045
//	}
//]
// ===========================================================================================
func (t *TelcoData) WriteBatch2(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	// Cast the data into the desired format
	var batch TelcoData
	err := json.Unmarshal([]byte(args[0]), &batch.Batch)
	if err != nil {
		return shim.Error(err.Error())
	}
	// Cast the struct in []byte format
	batchBytes, err := json.Marshal(batch)
	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(args[1]+`_`+args[2]+`_`+addPadding(args[3]), batchBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(batchBytes)
}

// =======================================================================================================
// QueryBatchRange2 returns the TelcoEntries that correspond to the "meas_info", "counter" and
// [fromTimestamp, toTimestamp) of choice.
//
//args[0]=meas_info
//args[1]=counter
//args[2]=fromTimestamp
//args[3]=toTimestamp
//args[4]=pageSize
//args[5]=bookmark
// ========================================================================================================
func (t *TelcoData) QueryBatchRange2(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	// Cast accordingly
	//return type of ParseInt is int64... but we need int32
	pageSize, err := strconv.ParseInt(args[4], 10, 32)
	if err != nil {
		return shim.Error(err.Error())
	}
	bookmark := args[5]
	fromTimestamp, err := strconv.ParseInt(args[2], 10, 64)
	if err != nil {
		return shim.Error(err.Error())
	}
	toTimestamp, err := strconv.ParseInt(args[3], 10, 64)
	if err != nil {
		return shim.Error(err.Error())
	}

	startKey := args[0] + `_` + args[1] + `_` + addPadding(args[2])
	endKey := args[0] + `_` + args[1] + `_` + addPadding(args[3])

	var entries []TelcoEntry
	loop := true

	for loop {
		resultsIterator, responseMetadata, err := stub.GetStateByRangeWithPagination(startKey, endKey, int32(pageSize), bookmark)
		if err != nil {
			return shim.Error(err.Error())
		}
		defer resultsIterator.Close()

		entries, err = constructQueryResponseFromIterator(resultsIterator, fromTimestamp, toTimestamp, entries)
		if err != nil {
			return shim.Error(err.Error())
		}

		if responseMetadata.FetchedRecordsCount == 0 {
			loop = false
		}
		bookmark = responseMetadata.Bookmark
	}

	entriesBytes, err := json.Marshal(entries)
	if err != nil {
		return shim.Error("Marshal failed!")
	}

	return shim.Success(entriesBytes)
}

// ===========================================================================================
// Same as WriteBatch2
// NOTE: CouchDB independed
// ===========================================================================================
func (t *TelcoData) WriteBatchComposite(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	// Cast the data into the desired format
	var batch TelcoData
	err := json.Unmarshal([]byte(args[0]), &batch.Batch)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Cast the struct in []byte format
	batchBytes, err := json.Marshal(batch)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Create composite key
	compo := "measInfo~counter~fromTimestamp"
	compoKey, err := stub.CreateCompositeKey(compo, []string{args[1], args[2], args[3]})
	if err != nil {
		return shim.Error("Creation of composite key failed!")
	}

	// Save the batch to world state.
	err = stub.PutState(compoKey, batchBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(batchBytes)
}

// ===========================================================================================
// Same as QueryBatchRange2.
// NOTE: CouchDB independed
// =========================================================================================== PENDING (IMPLEMENTATION)
func (t *TelcoData) QueryBatchRangeComposite(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	return shim.Success([]byte{0x00})
}

// ===========================================================================
// Adds padding to the received string (zeroes to the front).
// String length yet undecided...
// =========================================================================== // PENDING (IMPLEMENTATION)
func addPadding(str string) string {
	return str
}
