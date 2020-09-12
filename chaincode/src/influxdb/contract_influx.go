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

type Metadata struct { //must decide on the metadata : PENDING
	Digest   string `json:"digest"`
	Interval string `json:"interval"`
}
type Auxiliary struct {
	MetaArray []Metadata
}

type PointInflux struct {
	deviceID  string
	timestamp time.Time
	value     interface{}
}

func (p *PointInflux) String() string {
	return `{ 'deviceID' : '` + p.deviceID + `' , 'timestamp' : '` + fmt.Sprint(p.timestamp.String()) + `' , 'value' : '` + fmt.Sprint(p.value) + `' }`
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
type SmartContract struct {
	contractapi.Contract
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

// This function adds a new Device to the world state.
func (sc *SmartContract) CreateDevice(ctx contractapi.TransactionContextInterface, id string, location string) error {

	// Create the composite keys
	indexName := "location~deviceID"
	devIndex, err := ctx.GetStub().CreateCompositeKey(indexName, []string{location, id})
	if err != nil {
		return err
	}
	indexName = "deviceID~interval"
	devMeta, err := ctx.GetStub().CreateCompositeKey(indexName, []string{id, "0_0"}) //fromTimestamp_toTimestamp
	if err != nil {
		return err
	}

	// empty value for initializing
	value := []byte{0x00}

	// Update the world state -> must update the world state in a transaction manner; either both go in, or none... : PENDING
	err = ctx.GetStub().PutState(devIndex, value)
	if err != nil {
		return err
	}
	err = ctx.GetStub().PutState(devMeta, value)

	if err != nil {
		return err
	}

	return nil //success
}

// This function retrieves the metadata of all the ledger entries for the device at reference // previously called "QueryDevice"
func (sc *SmartContract) QueryDeviceMetadata(ctx contractapi.TransactionContextInterface, id string) (*Auxiliary, error) {

	var metaData []Metadata

	// Query the deviceID~interval index by deviceID
	// This will execute a key range query on all keys starting with the identifier of the device
	deviceResultIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("deviceID~interval", []string{id})
	if err != nil {
		return nil, err
	}

	// Iterate through result set and for each device found
	var i int
	for i = 0; deviceResultIterator.HasNext(); i++ {

		// Get the ledger entry
		deviceEntry, err := deviceResultIterator.Next()
		if err != nil {
			return nil, err
		}

		// split key, and ensure the "0_0" (i.e. init) ledger entry is not processed
		_, compositeKeyParts, err := ctx.GetStub().SplitCompositeKey(deviceEntry.Key)
		if err != nil {
			return nil, err
		}

		//returnedDeviceName := compositeKeyParts[0]
		returnedInterval := compositeKeyParts[1]
		//fmt.Printf("deviceID= %s, interval= %s\n", returnedDeviceName, returnedInterval)

		if returnedInterval == "0_0" {
			continue
		}

		// Get the value
		temp := deviceEntry.GetValue()
		var metaEntry Metadata
		err = json.Unmarshal(temp, &metaEntry)
		if err != nil {
			return nil, err
		}

		metaData = append(metaData, metaEntry)

	}

	data := new(Auxiliary)
	if len(metaData) == 0 { //escape null pointer error in case no ledger entries in array
		return nil, nil
	}
	data.MetaArray = metaData

	return data, nil // must be converted to return an array of Metadata
}

// This function stores new metadata on blockchain; used when new measurements come in (in json format)
func (sc *SmartContract) NewDeviceMetadataEntry(ctx contractapi.TransactionContextInterface, dataJson string) (*Metadata, error) {

	// Create the composite key
	indexName := "deviceID~interval"
	devMeta, err := ctx.GetStub().CreateCompositeKey(indexName, []string{"device_id_1", "1_3"}) // hardcoded fields must be calculated from the dataJson string... : PENDING
	if err != nil {
		return nil, err
	}

	metaEntry := Metadata{Digest: dataJson, Interval: "1_3"} // metadata need to be generated as required : PENDING

	metaEntryBytes, err := json.Marshal(metaEntry)
	if err != nil {
		return nil, err
	}
	err = ctx.GetStub().PutState(devMeta, metaEntryBytes)
	if err != nil {
		return nil, err
	}

	return &metaEntry, nil

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
