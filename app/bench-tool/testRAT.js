'use strict';
const fs = require('fs');
const Client = require('fabric-client');
const { exit } = require('process');

var myArgs = process.argv.slice(2);

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

//timestamp 
var base_timestamp = 201601251930
//global counter 
var commitedTxs = 0;

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

    initial_timer = process.hrtime();
    for (var i = 0; i < NUMBER_OF_TXS; i++) {
        invokeChaincode();
    }
    // var hrend = process.hrtime(hrstart)
    // console.info('Peer : %s : Execution time (hr): %ds %dms', PEER_NAME, hrend[0], hrend[1] / 1000000)

}

async function invokeChaincode() {

    let peerName = channel.getChannelPeer(PEER_NAME)

    var tx_id = client.newTransactionID();
    let tx_id_string = tx_id.getTransactionID();


    var meas_info = (Math.floor(10000000 + Math.random() * 90000000)).toString()
    var counter = (Math.floor(10000000 + Math.random() * 90000000)).toString()
    var cell_name = "8424bf520db261335d52a0b827a78538"
    var value = (Math.floor(Math.random() * 100)).toString()

    var timestamp = base_timestamp++
    var timestamp_string = timestamp.toString()

    var request = {
        targets: peerName,
        chaincodeId: CHAINCODE_ID,
        fcn: 'write',
        args: [meas_info, counter, cell_name, value, timestamp_string],
        chainId: CHANNEL_NAME,
        txId: tx_id
    };

    hrstart.push(process.hrtime());
    // console.log("#1 channel.sendTransactionProposal     Done.")
    let results = await channel.sendTransactionProposal(request);

    // Array of proposal responses
    var proposalResponses = results[0];

    var proposal = results[1];

    var all_good = true;
    for (var i in proposalResponses) {
        let good = false
        if (proposalResponses && proposalResponses[i].response &&
            proposalResponses[i].response.status === 200) {
            good = true;
            // console.log(`\tinvoke chaincode EP response #${i} was good`);
        } else {
            // console.log(`\tinvoke chaincode EP response #${i} was bad!!!`);
        }
        all_good = all_good & good
    }
    // console.log("#2 Looped through the EP results  all_good=", all_good)

    await setupTxListener(tx_id_string)
    // console.log('#3 Registered the Tx Listener')

    var orderer_request = {
        txId: tx_id,
        proposalResponses: proposalResponses,
        proposal: proposal
    };

    await channel.sendTransaction(orderer_request);
    // console.log("#4 channel.sendTransaction - waiting for Tx Event")

}


function setupTxListener(tx_id_string) {
    let event_hub = channel.getChannelEventHub(PEER_NAME);

    event_hub.registerTxEvent(tx_id_string, (tx, code, block_num) => {
        // console.log("#5 Received Tx Event")
        // console.log('\tThe chaincode invoke chaincode transaction has been committed on peer %s', event_hub.getPeerAddr());
        // console.log('\tTransaction %s is in block %s', tx, block_num);

        if (code !== 'VALID') {
            // console.log('\tThe invoke chaincode transaction was invalid, code:%s', code);
        } else {
            // console.log('\tThe invoke chaincode transaction was VALID.');
        }
        hrend.push(process.hrtime(hrstart[commitedTxs]));
        commitedTxs++;
        if (commitedTxs === NUMBER_OF_TXS) {
            var final_timer = process.hrtime(initial_timer);
            console.log("\t\t", final_timer);
            for (var timer of hrend) {
                total_time.push(timer[0] * 1000 + timer[1] / 1000000);
            }

            var sum = total_time.reduce((acc, c) => acc + c, 0);
            var average = sum / NUMBER_OF_TXS;

            console.log("\t\tAverage Latency to commit a Tx =  %d ms", average);
            console.log("\t\tSubmited Txs = ", commitedTxs);
            exit(0);
        }

    },
        // 3. Callback for errors
        (err) => {
            console.log(err);
        },
        { unregister: true, disconnect: false }
    );

    event_hub.connect();
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