package main

import (
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct {
	contractapi.Contract
}

/********	Note: Function signatures and structs will change accordingly during implementation.  ********/

// This is the struct that will receive the input data batch.
// The datatype of each data entry of the input batch is yet unclear.
type DataBatch struct {
	Batch []interface{}
}

// Writes a data batch to the ledger.
// It creates a ledger entry for every data batch. Every batch gets its own key, in the form of
// <deviceID>_<minTimestamp in inputu data batch>, to enable the use of the getStateByRangeWithPagination
// function effectively.
func (sc *SmartContract) WriteBatch(ctx contractapi.TransactionContextInterface) error {
	return nil
}

// Retrieves the ledger entries which correspond to the requested range/time interval, for a single device.
// It uses the getStateByRangeWithPagination(startKey, endKey, pageSize, bookmark) to retrieve the needed
// key-range, and then discards the unnecessary ledger entries (i.e. out of requested time interval),
// and returns the rest of the data.
func (sc *SmartContract) QueryDeviceRange(ctx contractapi.TransactionContextInterface) error {
	return nil
}

// Registers a new device on the ledger.
// It creates a composite key ("location~deviceID") which is used as an index for location-based querying
// purposes. (Here "location-based" refers to the location that the device registers at.)
func (sc *SmartContract) RegisterDevice(ctx contractapi.TransactionContextInterface) error {
	return nil
}

// Retrieves the ledger entries which correspond to the requested range/time interval, for all the devices in the
// specified location.
// It uses the "location~deviceID" composite keys to get the identifier of all devices in the specified
// location, and then works similarly to the QueryDeviceRange function to retrieve the correct data for
// each of those devices. It returns the results of all devices in a single struct; grouped per device.
func (sc *SmartContract) QueryLocationRange(ctx contractapi.TransactionContextInterface) error {
	return nil
}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error creating chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting chaincode: %s", err.Error())
	}

}
