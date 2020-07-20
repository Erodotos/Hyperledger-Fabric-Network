package main

import (
    "encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"

	"time"

	"context"

    "github.com/influxdata/influxdb-client-go"
	
)

// Type Document represents a document
type Document struct {
	ID        string `json:"id"`
	Owner     string  `json:"owner"`
	Pages     int    `json:"pages"`
	Location  string `json:"location"`
	Archived  bool   `json:"archived"`
}

// This function sets Archived to true
func (doc *Document) setArchivedTrue() {
	doc.Archived = true
}

// This function sets Archived to false
func (doc *Document) setArchivedFalse() {
	doc.Archived = false
}

type SmartContract struct {
	contractapi.Contract
}

// This function adds a new Document to the world state using id as key
func (sc *SmartContract) NewDocument(ctx contractapi.TransactionContextInterface, id string, owner string, pages int, location string) error {

	doc := Document{
		ID:   id,
		Owner:  owner,
		Pages: pages,
		Location:  location,
	}
	doc.setArchivedTrue()

	document_bytes, _ := json.Marshal(doc)

	return ctx.GetStub().PutState(id, document_bytes)
}

func (sc *SmartContract) QueryDocument(ctx contractapi.TransactionContextInterface, id string) (*Document, error) {
	document_bytes, err := ctx.GetStub().GetState(id)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if document_bytes == nil {
		return nil, fmt.Errorf("%s does not exist", id)
	}

	doc := new(Document)
	_ = json.Unmarshal(document_bytes, doc)

	return doc, nil
}

// This function updates the location of a Document
func (sc *SmartContract) UpdateLocation(ctx contractapi.TransactionContextInterface, id string, newlocation string) error {

	doc, err := sc.QueryDocument(ctx, id)

	if err != nil {
		return err
	}

	doc.Location = newlocation

	document_bytes, _ := json.Marshal(doc)

	return ctx.GetStub().PutState(id, document_bytes)
}

func (sc *SmartContract) ConnectToInflux(ctx contractapi.TransactionContextInterface, testText string) error {
	
	fmt.Println("%s",testText)
	userName := ""
    password := ""
    
    client := influxdb2.NewClient("http://influxdb_demo:8086", fmt.Sprintf("%s:%s",userName, password))
    
    writeApi := client.WriteApiBlocking("", "mydb")

	// line := fmt.Sprintf("stat,unit=temperature avg=%f,max=%f", 100, 100)
    // error := writeApi.WriteRecord(context.Background(), line)
	// fmt.Println(error)

    // create point using full params constructor
    p := influxdb2.NewPoint("stat",
        map[string]string{"unit": "temperature"},
        map[string]interface{}{"avg": 24.5, "max": 45},
        time.Now())
    // Write data
    err := writeApi.WritePoint(context.Background(), p)
    if err != nil {
        fmt.Printf("Write error: %s\n", err.Error())
    }

    client.Close()

	return nil
}

func (sc *SmartContract) ReadFromInflux(ctx contractapi.TransactionContextInterface, measurement string) (string, error) {

	userName := ""
	password := ""
	org := ""
	result_str := ""

	// Create client
	client := influxdb2.NewClient("http://influxdb_demo:8086", fmt.Sprintf("%s:%s", userName, password))
	// Get query client
	queryApi := client.QueryApi(org)

	//create flux query
	fq := `from(bucket:"mydb")|> range(start: -12h) |> filter(fn: (r) => r._measurement == "` + measurement + `")`

	// get QueryTableResult
	result, err := queryApi.Query(context.Background(), fq)

	//on error, return
	if err != nil {
		fmt.Printf("query error: %s\n", err.Error())
		return "", err
	}

	// Iterate over query response
	for result.Next() {
		// Notice when group key has changed
		if result.TableChanged() {
			group_str := fmt.Sprintf("-----------------------------group_key: %s", result.TableMetadata().String())
			result_str = result_str + group_str
		}
		// Get the data
		record_str := fmt.Sprintf("record: %s", result.Record().String())
		result_str = result_str + record_str
	}
	// check for an error
	if result.Err() != nil {
		return "", result.Err()
	}

	// Ensures background processes finishes
	client.Close()

	return result_str, nil
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