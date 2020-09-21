package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	pb "github.com/hyperledger/fabric-protos-go/peer"
)

type TelcoData struct {
	MeasInfo string       `json:"meas_info"` //col 1
	Batch    []TelcoEntry `json:"batch"`
}

type TelcoEntry struct {
	Counter   string `json:"counter"`   //col 2
	CellName  string `json:"cell_name"` //col 5
	Value     string `json:"value"`     //col 6
	Timestamp string `json:"timestamp"` //col 7, e.g. '201512200045' -> '%Y%m%d%H%M'
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
	} else if function == "QueryRangeWithPagination" {
		return t.QueryRangeWithPagination(stub, args)
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
//		"counter":"50331654",
//		"cell_name":"8424bf520db261335d52a0b827a78538",
//		"value":"4863",
//		"timestamp":"201512200045"
//	},
//	{
//		"counter":"50331655",
//		"cell_name":"8424bf520db261335d52a0b827a78538",
//		"value":"268",
//		"timestamp":"201512200045"
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

func (t *TelcoData) QueryRangeWithPagination(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	return shim.Success([]byte{0x00})
}
