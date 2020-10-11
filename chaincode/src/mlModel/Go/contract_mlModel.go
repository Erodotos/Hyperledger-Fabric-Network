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

	//CHAINCODE ENABLER
	/*
		err := shim.Start(new(SmartContract))
		if err != nil {
			fmt.Printf("Error starting Simple chaincode: %s", err)
		}
	*/

	//DEMO: 2 dense layers; no LSTM layers

	IMPORT_DIR := "./saved_model_demo"
	sess_options := &tf.SessionOptions{}

	model, err := tf.LoadSavedModel(IMPORT_DIR, []string{"TRAINING"}, sess_options)
	if err != nil {
		panic(err.Error())
	}
	defer model.Session.Close()

	fmt.Println("-----------------")
	fmt.Println(model.Session)
	fmt.Println("-----------------")
	fmt.Println(model.Graph)
	fmt.Println("-----------------")

	ops := model.Graph.Operations()
	for _, op := range ops {
		fmt.Println(op.Type() + "\t\t" + op.Name())
	}
	fmt.Println("-----------------")

	tensor, _ := tf.NewTensor([1][1][1]float32{{{float32(5.2980e+03)}}}) //declare the input's shape; [batch size = # of examples][y dimension of example's feature vector][ x dimension of example's feature vector = # of layer units]

	result, err := model.Session.Run(
		map[tf.Output]*tf.Tensor{
			model.Graph.Operation("sequential/dense_0/Sigmoid").Output(0): tensor, // Call the function that will run the 1st hidden layer to produce the inputs for the 2nd layer
		},
		[]tf.Output{
			model.Graph.Operation("sequential/dense_1/BiasAdd").Output(0), // Call the function of the 2nd layer that will produce its own results
		},
		nil,
	)

	if err != nil {
		fmt.Printf("Error running the session with input, err: %s\n", err.Error())
		return
	}

	fmt.Printf("Result value: %v \n", result[0].Value())

	//LSTM model: 1x10 hidden/lstm layers, 1x1 dense layers ------------- PENDING
	/*
		IMPORT_DIR := "./saved_model"
		sess_options := &tf.SessionOptions{}

		model, err := tf.LoadSavedModel(IMPORT_DIR, []string{"TRAINING"}, sess_options)
		if err != nil {
			panic(err.Error())
		}
		defer model.Session.Close()

		fmt.Println("-----------------")
		fmt.Println(model.Session)
		fmt.Println("-----------------")
		fmt.Println(model.Graph)
		fmt.Println("-----------------")

		ops := model.Graph.Operations()
		for _, op := range ops {
			fmt.Println(op.Type() + "\t\t" + op.Name())
		}
		fmt.Println("-----------------")
	*/
	/*
		ISSUE:
			LSTM cells use 3 sigmoid and 2 tanh functions;
			must further study the order of execution and then proceed to call them in order
	*/

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
