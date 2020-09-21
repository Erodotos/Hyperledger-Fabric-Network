package main

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"

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

func (s *SmartContract) newTelcoEntry(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	
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

	// ==== Check if Telco record already exists ====
	record_id := meas_info + "_" + counter
	recordAsBytes, err := stub.GetState(record_id)
	if err != nil {
		return shim.Error("Failed to get record : " + err.Error())
	} else if recordAsBytes != nil {
		fmt.Println("This record_id already exists: " + record_id)
		return shim.Error("This record already exists: " + record_id)
	}

	// ==== Create Telco Entry object and marshal to JSON ====
	record := TelcoEntry{
		MeasInfo: meas_info,
		Counter: counter, 
		CellName: cell_name,
		Value : value,
		Timestamp : timestamp,
	}

	valueAsBytes, err := json.Marshal(record)
	if err != nil {
		return shim.Error(err.Error())
	}

	// === Save record to world state ===
	err = stub.PutState(record_id, valueAsBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (s *SmartContract) updateValue(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	// ==== Input sanitation ====
	// if len(args) != 4 {
	// 	return shim.Error("Invalid number of arguments.")
	// }

	meas_info :=  strings.ToLower(args[0])

	counter := strings.ToLower(args[1])

	v, err :=  strconv.ParseFloat(args[2],32)
	if err != nil {
		return shim.Error("4th argument must be a numeric string")
	}
	value := float32(v)

	timestamp, err := strconv.ParseInt(args[3], 10, 64)
	if err != nil {
		return shim.Error("5th argument must be a numeric string")
	}

	// ==== Check if Telco record already exists ====
	record_id := meas_info + "_" + counter
	recordAsBytes, err := stub.GetState(record_id)
	if err != nil {
		return shim.Error("Failed to get record : " + err.Error())
	} else if recordAsBytes == nil {
		fmt.Println("This record_id does not exists: " + record_id)
		return shim.Error("This record does not exists: " + record_id)
	}

	fmt.Println("checkpoint 1")
	// ==== Unmarshal Teclo Entry from JSON ====
	record := new(TelcoEntry)
	err = json.Unmarshal(recordAsBytes, &record)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("checkpoint 2")

	// ==== Update value and timestamp ====
	
	record.Value = value
	record.Timestamp = timestamp
	
	recordJSONAsBytes, err := json.Marshal(record)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("checkpoint 3")

	// === Save updated record to world state ===
	err = stub.PutState(record_id, recordJSONAsBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("checkpoint 4")

	return shim.Success(nil)
}

func (s *SmartContract) getValue(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	// Pending
	return shim.Success(nil)
}

func (s *SmartContract) getValueHistory(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	// Pending
	return shim.Success(nil)
}

func main() {
	err := shim.Start(new(SmartContract))
	if err != nil {
		fmt.Printf("Error when starting chaincode : %s", err)
	}
}