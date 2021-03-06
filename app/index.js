
'use strict';
const fs = require('fs');
const Client = require('fabric-client');
var grpc = require('grpc');
var protoLoader = require('@grpc/proto-loader');

//gRPC: loading the proto file decriptors
const PROTO_FILE = 'gRPC/federated.proto';
const packageDefinition = protoLoader.loadSync(
    PROTO_FILE,
    {keepCase: true,
     longs: String,
     enums: String,
     defaults: true,
     oneofs: true
    });
const protoDescriptor = grpc.loadPackageDefinition(packageDefinition);
const grpc_client = new protoDescriptor.Server('0.0.0.0:9999', grpc.credentials.createInsecure())


// Constants for profile
const CONNECTION_PROFILE_PATH = './profiles/dev-connect.yaml'
// Client section configuration
const CLIENT_CONNECTION_PROFILE_PATH = './profiles/org1-client.yaml'

// Org & User
const ORG_NAME = 'org1'
const USER_NAME = 'Admin'
const PEER_NAME = 'peer0.org1.example.com'
const PEER_2_NAME = 'peer0.org1.example.com'
const CHANNEL_NAME = 'mychannel'
const CHAINCODE_ID = 'contract_rawOne'

//timestamp 
var base_timestamp = 201601251930

// Variable to hold the client
var client = {}
// Variable to hold the channel
var channel = {}

main()

async function main() {

    client = await setupClient()

    channel = await setupChannel()

    invokeChaincode()

}

async function invokeChaincode() {

    let peerName = channel.getChannelPeer(PEER_NAME)

    var tx_id = client.newTransactionID();
    let tx_id_string = tx_id.getTransactionID();


/*
    
    grpc_client.GetTransactionData({name: 'none'}, function(err, tx){
        if(err) {
            console.error(err)
        }else{
            var timestamp = base_timestamp++
            var timestamp_string = timestamp.toString()

            var request = {
                targets: peerName,
                chaincodeId: CHAINCODE_ID,
                fcn: 'write',
                args: [tx.meas_info, tx.counter, tx.cell_name, tx.value, timestamp_string],
                chainId: CHANNEL_NAME,
                txId: tx_id
            };
            console.log(request)
            
            console.log("#1 channel.sendTransactionProposal     Done.")

            async function submit(){
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
                        console.log(`\tinvoke chaincode EP response #${i} was good`);
                    } else {
                        console.log(`\tinvoke chaincode EP response #${i} was bad!!!`);
                    }
                    all_good = all_good & good
                }
                console.log("#2 Looped through the EP results  all_good=", all_good)

                await setupTxListener(tx_id_string)
                console.log('#3 Registered the Tx Listener')

                setTimeout(function () {
                    console.log(i);
                }, Math.floor(Math.random() * 1000));

                var orderer_request = {
                    txId: tx_id,
                    proposalResponses: proposalResponses,
                    proposal: proposal
                };

                await channel.sendTransaction(orderer_request);
                console.log("#4 channel.sendTransaction - waiting for Tx Event")

              }
              submit().then(()=>{}).catch((err)=>{console.log(err)});

            

            
        }
      })
   */   

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

    console.log("#1 channel.sendTransactionProposal     Done.")
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
            console.log(`\tinvoke chaincode EP response #${i} was good`);
        } else {
            console.log(`\tinvoke chaincode EP response #${i} was bad!!!`);
        }
        all_good = all_good & good
    }
    console.log("#2 Looped through the EP results  all_good=", all_good)

    await setupTxListener(tx_id_string)
    console.log('#3 Registered the Tx Listener')

    setTimeout(function () {
        console.log(i);
    }, Math.floor(Math.random() * 1000));

    var orderer_request = {
        txId: tx_id,
        proposalResponses: proposalResponses,
        proposal: proposal
    };

    await channel.sendTransaction(orderer_request);
    console.log("#4 channel.sendTransaction - waiting for Tx Event")
    
}


function setupTxListener(tx_id_string) {

    let event_hub = channel.getChannelEventHub(PEER_NAME);

    event_hub.registerTxEvent(tx_id_string, (tx, code, block_num) => {
        console.log("#5 Received Tx Event")
        console.log('\tThe chaincode invoke chaincode transaction has been committed on peer %s', event_hub.getPeerAddr());
        console.log('\tTransaction %s is in block %s', tx, block_num);

        if (code !== 'VALID') {
            console.log('\tThe invoke chaincode transaction was invalid, code:%s', code);
        } else {
            console.log('\tThe invoke chaincode transaction was VALID.');
        }
    },
        // 3. Callback for errors
        (err) => {
            console.log(err);
        },
        { unregister: true, disconnect: true }
    );

    event_hub.connect();
}


async function setupClient() {

    const client = Client.loadFromConfig(CONNECTION_PROFILE_PATH)

    client.loadFromConfig(CLIENT_CONNECTION_PROFILE_PATH)

    await client.initCredentialStores()
        .then((done) => {
            console.log("initCredentialStore(): ", done)
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