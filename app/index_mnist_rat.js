
'use strict';
const fs = require('fs');
const Client = require('fabric-client');

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
const CHAINCODE_ID = 'contract_mnist_rat'
const IMAGE_FILE = '../chaincode/src/mnist/RAT/data/28x28_grayscale_base64'


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

    ingestImage()
    //queryImage('b8f9e0c3931ac6d7adced0f80b805a679e2460651f5c9cfc3fd5693666ca0ad6')

}


async function ingestImage() {

    let t = new Date().getTime() 
    let peerName = channel.getChannelPeer(PEER_NAME)

    var tx_id = client.newTransactionID();
    let tx_id_string = tx_id.getTransactionID();

    fs.readFile(IMAGE_FILE, function (err,image_base64) {
      if (err) {
        return console.log(err);
      }

    
        var request = {
                targets: peerName,
                chaincodeId: CHAINCODE_ID,
                fcn: 'writeImage',
                args: ['imid1', image_base64],
                chainId: CHANNEL_NAME,
                txId: tx_id
        };
      
        console.log(request);

        console.log("#1 channel.sendTransactionProposal     Done.")

        async function submit() {

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

            await setupTxListener(tx_id_string, t)
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

        submit().then(()=>{}).catch((err)=>{console.log(err)})

    });


}


function queryImage(tx_id) {
    let t = new Date().getTime()
    let peerName = channel.getChannelPeer(PEER_NAME)

    async function submit() {

        let results = await channel.queryTransaction(tx_id, peerName, true, false)

        let args = await results.transactionEnvelope.payload.data.actions[0].payload.chaincode_proposal_payload.input.chaincode_spec.input.args

        let result = {
            image_id: args[1].toString(),
            image_base64: args[2].toString(),
            arrived: t,
            completed: new Date().getTime()
        };
        
       return result
    }

    submit().then((result)=>{console.log(result); console.log('\nquery_time_ms: %s', (result.completed-result.arrived))}).catch((err)=>{console.log(err)});
}



function setupTxListener(tx_id_string, t) {

    let event_hub = channel.getChannelEventHub(PEER_NAME);

    event_hub.registerTxEvent(tx_id_string, (tx, code, block_num) => {
        console.log("#5 Received Tx Event")
        console.log('\tThe chaincode invoke chaincode transaction has been committed on peer %s', event_hub.getPeerAddr());
        console.log('\tTransaction %s is in block %s', tx, block_num);

        if (code !== 'VALID') {
            console.log('\tThe invoke chaincode transaction was invalid, code:%s', code);
        } else {
            console.log('\tThe invoke chaincode transaction was VALID.');
            let tt = new Date().getTime() - t
            console.log('\ningest_time_ms: %s', tt.toString())
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