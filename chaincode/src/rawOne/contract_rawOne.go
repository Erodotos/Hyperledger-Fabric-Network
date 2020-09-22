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

//SmartContract
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
	Timestamp 	string	`json:"timestamp"`
	Record 		TelcoEntry	`json:"record"`
}

func (s *SmartContract) Init(stub shim.ChaincodeStubInterface) peer.Response {
	fmt.Println("Chaincode instantiated")
	return shim.Success(nil)
}

func (s *SmartContract) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	function, args := stub.GetFunctionAndParameters()

	if function == "newTelcoEntry" {
		return s.newTelcoEntry(stub, args)
	} else if function == "updateValue" {
		return s.updateValue(stub, args)
	}

	return shim.Success(nil)
}

func (s *SmartContract) write(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	// ==== Input sanitation ====
	if len(args) != 5 {
		return shim.Error("Invalid number of arguments.")
	}

	meas_info :=  strings.ToLower(args[0])
	cell_name :=  strings.ToLower(args[2])
	if (len(cell_name) != 32){
		return shim.Error("Cell name must have 32 characters length")
	}

	counter := strings.ToLower(args[1])

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

func (s *SmartContract) queryRecords(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 1 {
		return shim.Error("Incorrect number of arguments. Expecting only 1")
	}

	queryString := args[0]

	resultsIterator, err := stub.GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	queryResults, err := constructQueryResponseFromIterator(resultsIterator)
	if err != nil {
		return shim.Error(err.Error())
	}

	recordsBytes, err := json.Marshal(queryResults)
	if err != nil {
		return shim.Error("Marshal failed!")
	}
	return shim.Success(recordsBytes)
}

func (s *SmartContract) queryRecordsWithPagination(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//arg[0]=queryString -> to declare meas_info, counter selector
	//arg[1]=pageSize
	//arg[2]=bookmark
	//arg[3]=fromTimestamp -> to declare the time interval
	//arg[4]=toTimestamp

	// ==== Input sanitation ====
	queryString := args[0]

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

	records, err := constructQueryResponseFromIterator(resultsIterator)
	if err != nil {
		return shim.Error(err.Error())
	}

	recordsBytes, err := json.Marshal(records)
	if err != nil {
		return shim.Error("Marshal failed!")
	}

	return shim.Success(recordsBytes)
}

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
		
		var recordInstance = new(RecordHistory)

		recordInstance.TxId = response.TxId
		recordInstance.Timestamp = time.Unix(response.Timestamp.Seconds, int64(response.Timestamp.Nanos)).String()

		var value TelcoEntry
		err = json.Unmarshal(response.Value, &value)
		if err != nil {
			return nil, "", err
		}
		recordInstance.Record = record
		
		historyArray = append(historyArray, value)
	}

	responseBytes, err := json.Marshal(historyArray)
	if err != nil {
		return shim.Error("Marshal failed!")
	}

	return shim.Success(responseBytes)
}

func constructQueryResponseFromIterator(resultsIterator shim.StateQueryIteratorInterface) (*[]TelcoEntry, error) {

	// Declare TelcoEntry collector
	var recordsArray []TelcoEntry

	// Get the query results
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, "", err
		}

		// Get the retrieved record
		var record TelcoEntry
		err = json.Unmarshal(queryResponse.Value, &record)
		if err != nil {
			return nil, "", err
		}

		recordsArray = append(recordsArray, record)

	}

	return &entries, nil
}

func main() {
	err := shim.Start(new(SmartContract))
	if err != nil {
		fmt.Printf("Error when starting chaincode : %s", err)
	}
}