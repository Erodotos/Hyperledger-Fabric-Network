'use strict';
const fs = require('fs');
const Client = require('fabric-client');
const { exit } = require('process');

var myArgs = process.argv.slice(2);//get arguments from command line

// Arguments Parcing
const ORG_NAME = myArgs[0];
const USER_NAME = myArgs[1];
const PEER_NAME = myArgs[2];
const CHANNEL_NAME = myArgs[3];
const CHAINCODE_ID = myArgs[4];
const NUMBER_OF_TXS = parseInt(myArgs[5]);


// Constants for profile
const CONNECTION_PROFILE_PATH = './profiles/dev-connect.yaml';

var CLIENT_CONNECTION_PROFILE_PATH;
// Client section configuration
if (ORG_NAME === 'org1') {
    CLIENT_CONNECTION_PROFILE_PATH = './profiles/org1-client.yaml';
} else if (ORG_NAME === 'org2') {
    CLIENT_CONNECTION_PROFILE_PATH = './profiles/org2-client.yaml';
} else {
    console.log("Exiting : Ivalid Organization name");
    exit(0);
}

//global counter 
var numTxs = 0;

// Variable to hold the client
var client = {}
// Variable to hold the channel
var channel = {}

var initial_timer;
var hrstart = [];
var hrend = [];
var total_time = [];

main()

async function main() {
    client = await setupClient();

    channel = await setupChannel();

    let id = 'imid0';
    
    initial_timer = process.hrtime();
    for (var i = 0; i < NUMBER_OF_TXS; i++) {
        queryImage(id); //async call
    }
    
    
}


async function queryImage(id) {

    let peerName = channel.getChannelPeer(PEER_NAME)

    let request = {
         targets: peerName,
         chaincodeId: CHAINCODE_ID,
         fcn: 'queryImage',
         args: [id]
     };

     // send the query proposal to the peer
     hrstart.push(process.hrtime());
     let response = await channel.queryByChaincode(request);
     hrend.push(process.hrtime(hrstart[numTxs])); //diff of start and end time
     numTxs++;
     if (numTxs === NUMBER_OF_TXS) {
         var final_timer = process.hrtime(initial_timer);
         console.log("\t\t", final_timer);
         for (var timer of hrend) {
             total_time.push(timer[0] * 1000 + timer[1] / 1000000);
         }

         var sum = total_time.reduce((acc, c) => acc + c, 0);
         var average = sum / NUMBER_OF_TXS;

         //console.log("\t\tAverage Retrieval Latency =  %d ms", average);
         //console.log("\t\tQueried Txs = ", numTxs);
         exit(0);
     }

    return 
}


async function setupClient() {

    const client = Client.loadFromConfig(CONNECTION_PROFILE_PATH)

    client.loadFromConfig(CLIENT_CONNECTION_PROFILE_PATH)

    await client.initCredentialStores()
        .then((done) => {
            // console.log("initCredentialStore(): ", done)
        })

    let userContext = await client.loadUserFromStateStore(USER_NAME)
    if (userContext == null) {
        console.log("User NOT found in credstore: ", USER_NAME)
        process.exit(1)
    }

    client.setUserContext(userContext, true)

    return client
}

async function setupChannel() {
    try {
        channel = await client.getChannel(CHANNEL_NAME, true)
    } catch (e) {
        console.log("Could NOT create channel: ", CHANNEL_NAME)
        process.exit(1)
    }

    return channel
}