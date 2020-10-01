package main

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-protos-go/peer"
)

//SmartContract object! usually empty
type SmartContract struct {
}

//For this implementaion I assumed that key is
//MeasInfo and Counter. We use this struct to
//store data in the ledger.
type TelcoEntry struct {
	MeasInfo  string  `json:"meas_info"`   //col 1
	Counter   string  `json:"counter"`   //col 2
	CellName  string  `json:"cell_name"` //col 5
	Value     float32 `json:"value"`     //col 6
	Timestamp int64   `json:"timestamp"` //col 7, e.g. '201512200045' -> '%Y%m%d%H%M', this format can be used with numeric comparisons
}

type RecordHistory struct{
	TxId 		string		`json:"tx_id"`
	Timestamp 	string		`json:"timestamp"`
	Record 		TelcoEntry	`json:"record"`
}

// instantiates smart contract
func (s *SmartContract) Init(stub shim.ChaincodeStubInterface) peer.Response {
	fmt.Println("Chaincode instantiated")
	return shim.Success(nil)
}

// this functions is the chaincode entry point 
func (s *SmartContract) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	function, args := stub.GetFunctionAndParameters()

	if function == "write" {
		return s.write(stub, args)
	} else if function == "queryRecords" {
		return s.queryRecords(stub, args)
	} else if function == "queryRecordsWithPagination" {
		return s.queryRecordsWithPagination(stub, args)
	} else if function == "getRecordHistory" {
		return s.getRecordHistory(stub, args)
	}

	return shim.Success(nil)
}

// args[0] : meas_info 
// args[1] : counter
// args[2] : cell_name
// args[3] : value
// args[4] : timestamp
func (s *SmartContract) write(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	// ==== Input sanitation ====
	if len(args) != 5 {
		return shim.Error("Invalid number of arguments.")
	}

	meas_info :=  strings.ToLower(args[0])

	counter := strings.ToLower(args[1])

	cell_name :=  strings.ToLower(args[2])
	if (len(cell_name) != 32){
		return shim.Error("Cell name must have 32 characters length")
	}

	v, err :=  strconv.ParseFloat(args[3],32)
	if err != nil {
		return shim.Error("4th argument must be a numeric string")
	}
	value := float32(v)

	timestamp, err := strconv.ParseInt(args[4], 10, 64)
	if err != nil {
		return shim.Error("5th argument must be a numeric string")
	}

	// ==== Create record key ====
	record_id := meas_info + "_" + counter

	// ==== Create Telco Entry object and marshal to JSON ====
	record := TelcoEntry{
		MeasInfo: meas_info,
		Counter: counter, 
		CellName: cell_name,
		Value : value,
		Timestamp : timestamp,
	}

	recordAsBytes, err := json.Marshal(record)
	if err != nil {
		return shim.Error(err.Error())
	}

	// === Save record to world state ===
	err = stub.PutState(record_id, recordAsBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

// eg query string {"selector":{"$timestamp" {"$gt" : 0}}
// this query retrieves all records with timestamp greater than 0
// args[0] : queryString 

// Need debugging
// Error: endorsement failure during invoke. response: status:500 message:
// "GET_QUERY_RESULT failed: transaction ID: 9140274f4bd77dc877871f8dfca8eedd9293ad1694c31b6dbd9cfaafc628d124: invalid character '{' after object key" 
func (s *SmartContract) queryRecords(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	fmt.Println("I am in")
	if len(args) < 1 {
		return shim.Error("Incorrect number of arguments. Expecting only 1")
	}

	queryString := args[0]

	resultsIterator, err := stub.GetQueryResult(queryString)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	var records []TelcoEntry

	records, err = constructQueryResponseFromIterator(resultsIterator,records)
	if err != nil {
		return shim.Error(err.Error())
	}

	recordsBytes, err := json.Marshal(records)
	if err != nil {
		return shim.Error("Marshal failed!")
	}

	fmt.Println(recordsBytes)

	return shim.Success(recordsBytes)
}

// eg query string {"selector":{"$timestamp" {"$gt" : 0}}
// this query retrieves all records with timestamp greater than 0
// args[0] : queryString 
// args[1] : pageSize
// args[2] : bookmark
func (s *SmartContract) queryRecordsWithPagination(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	// ==== Input sanitation ====
	queryString := args[0]

	pageSize, err := strconv.ParseInt(args[1], 10, 32)
	if err != nil {
		return shim.Error(err.Error())
	}

	bookmark := args[2]

	var records []TelcoEntry
	loop := true

	for loop {

		resultsIterator, responseMetadata, err := stub.GetQueryResultWithPagination(queryString, int32(pageSize), bookmark)
		if err != nil {
			return shim.Error(err.Error())
		}
		defer resultsIterator.Close()

		records, err = constructQueryResponseFromIterator(resultsIterator, records)
		if err != nil {
			return shim.Error(err.Error())
		}

		if responseMetadata.FetchedRecordsCount == 0 {
			loop = false
		}

		bookmark = responseMetadata.Bookmark

		fmt.Println("paginated results")
	}

	recordsBytes, err := json.Marshal(records)
	if err != nil {
		return shim.Error("Marshal failed!")
	}
	
	fmt.Println(recordsBytes)

	return shim.Success(recordsBytes)
}

//args[0] : record_id
func (s *SmartContract) getRecordHistory(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	
	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting only 1")
	}

	record_id := args[0]

	resultsIterator, err := stub.GetHistoryForKey(record_id)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	var historyArray []RecordHistory

	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}
		
		var recordInstance RecordHistory

		recordInstance.TxId = response.TxId
		recordInstance.Timestamp = time.Unix(response.Timestamp.Seconds, int64(response.Timestamp.Nanos)).String()

		var value TelcoEntry
		err = json.Unmarshal(response.Value, &value)
		if err != nil {
			return shim.Error(err.Error())
		}
		recordInstance.Record = value
		
		historyArray = append(historyArray, recordInstance)
	}

	responseBytes, err := json.Marshal(historyArray)
	if err != nil {
		return shim.Error("Marshal failed!")
	}

	fmt.Println(responseBytes)

	return shim.Success(responseBytes)
}

// this is an utility function
func constructQueryResponseFromIterator(resultsIterator shim.StateQueryIteratorInterface, recordsArray []TelcoEntry) ([]TelcoEntry, error) {

	// Get the query results
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		// Get the retrieved record
		var record TelcoEntry
		err = json.Unmarshal(queryResponse.Value, &record)
		if err != nil {
			return nil, err
		}

		recordsArray = append(recordsArray, record)

	}

	return recordsArray, nil
}

func main() {
	err := shim.Start(new(SmartContract))
	if err != nil {
		fmt.Printf("Error when starting chaincode : %s", err)
	}
}