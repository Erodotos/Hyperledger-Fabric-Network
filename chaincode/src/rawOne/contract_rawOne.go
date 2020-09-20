package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	influxdb2 "github.com/influxdata/influxdb-client-go"
	"github.com/influxdata/influxdb-client-go/api"
)

type DeviceInfo struct { //contains details about the device
	Location           string `json:"location"`
	LastWriteTimestamp int64  `json:"lastWriteTimestamp"`
}

type Metadata struct { //must decide on the metadata : PENDING
	Digest  string `json:"digest"`  // the corresponding fromTimestamp_toTimestamp can be found in the related composite key
	IsEmpty bool   `json:"isEmpty"` // 'true' indicates an empty data batch; used to indicate a WriteTiInfluxError as well
}
type Auxiliary struct {
	MetaArray []Metadata
}

// for retrieving data from influx
type PointInflux struct {
	deviceID  string
	timestamp int64
	value     interface{}
}

func (p *PointInflux) String() string {
	return fmt.Sprintf(`{ 'deviceID' : '%s' , 'timestamp' : '%v' , 'value' : '%v' }`, p.deviceID, p.timestamp, p.value)
}

//The connection's struct
type InfluxDB struct {
	client   influxdb2.Client
	writeAPI api.WriteApi
	queryAPI api.QueryApi
}

//The struct into which the received points (from the chaincode call) are unmarshalled (i.e. json -> golang struct)
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

// Returns a string representation of a PointsJson struct
func (p *PointsJson) String() string {

	str := `[`

	for _, pnt := range p.Points {

		str = str + `(` + pnt.Measurement

		for _, t := range pnt.Tags {
			str = str + `,` + t.Key + `:` + t.Value
		}

		for _, f := range pnt.Fields {
			str = str + `,` + f.Key + `:` + f.Value
		}

		str = str + `)`
	}

	str = str + `]`

	return str
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
		rec = PointInflux{deviceID: tuple.Measurement(), timestamp: tuple.Time().Unix(), value: tuple.Value()}

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

// This function adds a new Device to the world state. //TESTED
// id= the device's unique identifier
// location= the device's location
// tmstamp= the timestamp on which the
func (sc *SmartContract) CreateDevice(ctx contractapi.TransactionContextInterface, id string, location string, tmstamp string) (*DeviceInfo, error) {

	// Create the composite keys
	indexName := "deviceID~fromToTimestamp"
	devMeta, err := ctx.GetStub().CreateCompositeKey(indexName, []string{id, "0_0"}) //fromTimestamp_toTimestamp
	if err != nil {
		return nil, err
	}
	indexName = "location~deviceID"
	devLocIndex, err := ctx.GetStub().CreateCompositeKey(indexName, []string{location, id})
	if err != nil {
		return nil, err
	}
	// empty value for initializing
	value := []byte{0x00}

	//Create the ordinary keys
	deviceInfokey := id
	tm, err := strconv.ParseInt(tmstamp, 10, 64)
	if err != nil {
		return nil, err
	}
	deviceInfo := DeviceInfo{Location: location, LastWriteTimestamp: tm}
	deviceInfoBytes, err := json.Marshal(deviceInfo)
	if err != nil {
		return nil, err
	}

	// Update the world state -> must update the world state in a transaction manner; either both go in, or none... : PENDING
	err = ctx.GetStub().PutState(devMeta, value)
	if err != nil {
		return nil, err
	}
	err = ctx.GetStub().PutState(devLocIndex, value)
	if err != nil {
		return nil, err
	}
	err = ctx.GetStub().PutState(deviceInfokey, deviceInfoBytes)
	if err != nil {
		return nil, err
	}

	return &deviceInfo, nil //success
}

// This function retrieves the metadata of all the ledger entries for the device at reference //TESTED
func (sc *SmartContract) QueryDeviceMetadata(ctx contractapi.TransactionContextInterface, id string) (*Auxiliary, error) {

	var metaData []Metadata

	// Query the deviceID~fromToTimestamp index by deviceID
	// This will execute a key range query on all keys starting with the identifier of the device
	deviceResultIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("deviceID~fromToTimestamp", []string{id})
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
		returnedfromToTimestamp := compositeKeyParts[1]
		//fmt.Printf("deviceID= %s, fromToTimestamp= %s\n", returnedDeviceName, returnedfromToTimestamp)

		if returnedfromToTimestamp == "0_0" {
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

// This function writes to influx; auxiliary. //TESTED
// Does not return an error if the database it attempts to write in does not exist. //PENDING
func WriteToInflux(pts PointsJson) error {

	infdb := InfluxDB{}
	_ = infdb.initConnection("http://influxdb_demo:8086", "mydb", "", "", 2)

	for _, point := range pts.Points { //for each point

		tags_map := make(map[string]string)
		for _, tag := range point.Tags { //create the tags
			tags_map[tag.Key] = tag.Value
		}

		fields_map := make(map[string]interface{})
		for _, field := range point.Fields { // create the fields
			fields_map[field.Key] = field.Value
		}

		//parse the timestamp (received as an integer contained in a string) into the biggest int available
		tm, err := strconv.ParseInt(point.Timestamp, 10, 64)
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

// This function writes to influx with a chaincode call; defined on the contract. // TESTED
func (sc *SmartContract) WriteToInflux(ctx contractapi.TransactionContextInterface, dataJson string) error {

	//data pre-processing
	var pts PointsJson
	err := json.Unmarshal([]byte(dataJson), &pts)
	if err != nil {
		return err
	}

	return WriteToInflux(pts)

}

// Computes the digest of a PointsJson struct; uses its string representation
func CalculateDigest(pts string) string { //PENDING
	return pts
}

// This function stores new metadata on blockchain // TESTED
func (sc *SmartContract) WriteBatch(ctx contractapi.TransactionContextInterface, id, fromTimestamp, toTimestamp string, dataJson string) (*Metadata, error) {

	//Check if the device is registered/created; if not, return error, else get its details.
	deviceInfo, err := ctx.GetStub().GetState(id)
	if err != nil {
		return nil, errors.New("Device does not exist!") //err
	}
	var dInfo DeviceInfo
	err = json.Unmarshal([]byte(deviceInfo), &dInfo)
	if err != nil {
		return nil, errors.New("DeviceInfo Unmarshal failed!") //err
	}

	//update device info struct
	tm, err := strconv.ParseInt(toTimestamp, 10, 64)
	if err != nil {
		return nil, err
	}
	dInfo.LastWriteTimestamp = tm

	//Check if the data batch is empty
	var pts PointsJson
	err = json.Unmarshal([]byte(dataJson), &pts)
	if err != nil {
		return nil, errors.New("PointsJson unmarshal failed!") //err
	}
	isEmpty := false
	if len(pts.Points) == 0 {
		isEmpty = true
	} else {
		//Since device exists and there are points to write; attempt to write points in influx
		err = WriteToInflux(pts)

		// if writing to influx fails
		if err != nil {
			// trigger an empty entry in blockchain
			pts.Points = nil
			isEmpty = true
		}
	}

	// If no data in the data batch skip the digest computation,
	// else set it to false and calculate the digest.
	digest := ""
	if !isEmpty {
		digest = CalculateDigest(pts.String())
	}

	// Prepare the value to be added to the world state
	metaEntry := Metadata{Digest: digest, IsEmpty: isEmpty}
	metaEntryBytes, err := json.Marshal(metaEntry)
	if err != nil {
		return nil, errors.New("Metadata marshal failed!") //err
	}

	// Create the composite key
	indexName := "deviceID~fromToTimestamp"
	devMeta, err := ctx.GetStub().CreateCompositeKey(indexName, []string{id, fromTimestamp + `_` + toTimestamp})
	if err != nil {
		return nil, errors.New("Creation of composite key failed!") //err
	}

	//Update the world state
	//device info
	deviceInfo, err = json.Marshal(dInfo)
	if err != nil {
		return nil, errors.New("World state update: DeviceInfo Marshal failed!") //err
	}
	err = ctx.GetStub().PutState(id, deviceInfo)
	if err != nil {
		return nil, errors.New("World state update: Updating the world state with DeviceInfo failed!") //err
	}

	//metadata
	err = ctx.GetStub().PutState(devMeta, metaEntryBytes)
	if err != nil {
		return nil, errors.New("World state update: Updating the world state with metadata failed!") //err
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
