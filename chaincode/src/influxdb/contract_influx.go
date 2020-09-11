package main

import (
	"context"
	"encoding/json"
	"fmt"
	"strconv"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	influxdb2 "github.com/influxdata/influxdb-client-go"
	"github.com/influxdata/influxdb-client-go/api"
)

type compositeKey struct { // a dummy reference point
	deviceID      string
	location      string
	fromTimestamp time.Time
	toTimestamp   time.Time
}

type PointInflux struct {
	deviceID  string
	timestamp time.Time
	value     interface{}
}

func (p *PointInflux) String() string {
	return `{ 'deviceID' : '` + p.deviceID + `' , 'timestamp' : '` + fmt.Sprint(p.timestamp.String()) + `' , 'value' : '` + fmt.Sprint(p.value) + `' }`
}

//for testing
func check(e error) {
	if e != nil {
		panic(e)
	}
}

//The connection's struct
type InfluxDB struct {
	client   influxdb2.Client
	writeAPI api.WriteApi
	queryAPI api.QueryApi
}

//The struct into which the received points are unmarshalled (i.e. json -> golang struct)
type PointsJson struct {
	Points []struct {
		Measurement string `json:"measurement"`
		Tags        []struct {
			Key   string `json:"key"`
			Value string `json:"value"`
		} `json:"tags"`
		Fields []struct {
			Key   string `json:"key"`
			Value string `json:"value"`
		} `json:"fields"`
		Timestamp string `json:"timestamp"`
	} `json:"points"`
}

//Initializes the connection's client, writeApi and queryApi.
func (infdb *InfluxDB) initConnection(databaseURL, bucketName, username, password string, batchSize uint) error {

	infdb.client = influxdb2.NewClientWithOptions(databaseURL, fmt.Sprintf("%s:%s", username, password), influxdb2.DefaultOptions().SetBatchSize(batchSize))
	infdb.writeAPI = infdb.client.WriteApi("my-org", bucketName)
	infdb.queryAPI = infdb.client.QueryApi( /*"my-org"*/ "")

	return nil
}

func (infdb *InfluxDB) terminateConnection() error {

	infdb.client.Close()

	return nil
}

// Type Device represents a device
type Device struct {
	ID       string `json:"id"`
	Location string `json:"location"`
}

type SmartContract struct {
	contractapi.Contract
}

func (sc *SmartContract) WriteToInflux(ctx contractapi.TransactionContextInterface, dataJson string) error {

	infdb := InfluxDB{}
	_ = infdb.initConnection("http://influxdb_demo:8086", "mydb", "", "", 2)

	var pts PointsJson
	err := json.Unmarshal([]byte(dataJson), &pts)
	if err != nil {
		return err
	}

	for _, point := range pts.Points { //for each point

		tags_map := make(map[string]string)
		for _, tag := range point.Tags { //create the tags
			tags_map[tag.Key] = tag.Value
		}

		fields_map := make(map[string]interface{})
		for _, field := range point.Fields { // create the fields
			fields_map[field.Key] = field.Value
		}

		tm, err := strconv.ParseInt(point.Timestamp, 10, 64) //parse the timestamp into the biggest int available
		if err != nil {
			panic(err)
		}

		point_time := time.Unix(tm, 0)

		p := influxdb2.NewPoint(
			point.Measurement,
			tags_map,
			fields_map,
			point_time)

		// write asynchronously
		infdb.writeAPI.WritePoint(p)
	}

	infdb.writeAPI.Flush()

	return nil
}

//Retrieves the points for the specified time period, meausurement and bucket.
func (sc *SmartContract) ReadFromInflux(ctx contractapi.TransactionContextInterface, database string, retentionPolicy string, start string, stop string, aux string, queryType string) (string, error) {

	c := InfluxDB{}
	_ = c.initConnection("http://influxdb:8086", database, "", "", 2) // hardcoded for testing

	//create flux query
	var fq string
	if queryType == "true" { // query an individual device; device_id must be unique (not per location, but GLOBALLY)
		fq = `from(bucket: "` + database + `/` + retentionPolicy + `")	|> range(start: ` + start + `, stop: ` + stop + `) |> filter(fn: (r) => r._measurement == "` + aux + `")`
	} else { // query all devices in a given location
		fq = `from(bucket: "` + database + `/` + retentionPolicy + `")	|> range(start: ` + start + `, stop: ` + stop + `) |> filter(fn: (r) => r.location == "` + aux + `")`
	}

	// get QueryTableResult
	result, err := c.queryAPI.Query(context.Background(), fq)

	//on error, return
	if err != nil {
		fmt.Printf("Query Error: %s\n", err.Error())
		return "", err
	}

	//create slice (i.e. dynamic array)
	var recSet []PointInflux

	//For every retrieved record
	for result.Next() {

		tuple := result.Record()
		var rec PointInflux
		rec = PointInflux{deviceID: tuple.Measurement(), timestamp: tuple.Time(), value: tuple.Value()}

		recSet = append(recSet, rec)

	}

	// check for an error in result-set iteration
	if result.Err() != nil {
		return "", result.Err()
	}

	// return the points into a json format
	resultStr := "{["
	i := 0
	for i < (len(recSet) - 1) {
		resultStr = resultStr + recSet[i].String() + " , "
		i++
	}

	if len(recSet) > 0 {
		resultStr = resultStr + recSet[i].String()
	}
	resultStr = resultStr + "]}"

	// Ensures background processes finishes
	c.terminateConnection()

	return resultStr, nil
}

// This function adds a new Device to the world state using id as key
func (sc *SmartContract) CreateDevice(ctx contractapi.TransactionContextInterface, id string, location string) error {

	dev := Device{
		ID:       id,
		Location: location,
	}

	device_bytes, _ := json.Marshal(dev)

	return ctx.GetStub().PutState(id, device_bytes)
}

func (sc *SmartContract) QueryDevice(ctx contractapi.TransactionContextInterface, id string) (*Device, error) {
	device_bytes, err := ctx.GetStub().GetState(id)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if device_bytes == nil {
		return nil, fmt.Errorf("%s does not exist", id)
	}

	dev := new(Device)
	_ = json.Unmarshal(device_bytes, dev)

	return dev, nil
}

// This function updates the location of a Device
func (sc *SmartContract) UpdateLocation(ctx contractapi.TransactionContextInterface, id string, newlocation string) error {

	// start of test code----------------
	/*
		f, err := os.Create("/home/chaincode/test_file_04_09_2020") //creates a file in the current directory
		check(err)

		n3, err := f.WriteString("this is a string\n")
		check(err)
		fmt.Printf("wrote %d bytes\n", n3)

		f.Close() //closes the file on return
	*/
	// end of test code------------------

	dev, err := sc.QueryDevice(ctx, id)

	if err != nil {
		return err
	}

	dev.Location = newlocation

	device_bytes, _ := json.Marshal(dev)

	return ctx.GetStub().PutState(id, device_bytes)
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

//docker exec -it container_name bash
