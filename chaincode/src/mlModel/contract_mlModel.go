package main

import (
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	pb "github.com/hyperledger/fabric-protos-go/peer"
	tf "github.com/tensorflow/tensorflow/tensorflow/go"
	/*
		Set-up Tensorflow:
			1) Install Tensorflow for C:
					-  https://github.com/tensorflow/tensorflow/issues/24281 (relative github issue)
					-  https://www.tensorflow.org/install/lang_c (latest tar file)
			2) Import Tensorflow (set version to v1.14.0 in the go.mod file):
				This is mostly for compatibility with the given Python project; might upgrade it later on.
	*/)

type SmartContract struct {
}

// =========
// Main
// =========
func main() {
	/*
		err := shim.Start(new(SmartContract))
		if err != nil {
			fmt.Printf("Error starting Simple chaincode: %s", err)
		}
	*/

	/*
		ISSUE #1: Must find how to properly export a trained model; using checkpoints is only for getting familiar
					with the APIs

		ISSUE #2: Must transfer the model on the chaincode's container when loading it for the first time.
				After the first load, the model's files should be stored on the blockchain; don't yet know how.
	*/
	IMPORT_DIR := "./saved_model"
	sess_options := &tf.SessionOptions{}

	model, err := tf.LoadSavedModel(IMPORT_DIR, []string{"TRAINING"}, sess_options)
	if err != nil {
		panic(err.Error())
	}
	fmt.Println("-----------------")
	fmt.Println(model.Session)
	fmt.Println("-----------------")
	fmt.Println(model.Graph)
	fmt.Println("-----------------")
	ops := model.Graph.Operations()
	for _, op := range ops {
		fmt.Println(op.Name())
	}
	fmt.Println("-----------------")
}

// ===========================
// Init initializes chaincode
// ===========================
func (t *SmartContract) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

// ========================================
// Invoke - Our entry point for Invocations
// ========================================
func (t *SmartContract) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	function, args := stub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)

	// Handle different functions
	if function == "Predict" {
		return t.Predict(stub, args)
	}

	fmt.Println("invoke did not find func: " + function) //error
	return shim.Error("Received unknown function invocation")
}

func (t *SmartContract) Predict(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	return shim.Success([]byte{0x00})
}
