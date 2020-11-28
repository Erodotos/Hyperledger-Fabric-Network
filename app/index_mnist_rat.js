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
const IMAGE_FILE = './mnist_image_example/28x28_grayscale_base64'


// Variable to hold the client
var client = {}
// Variable to hold the channel
var channel = {}



main()

async function main() {

    client = await setupClient()

    channel = await setupChannel()

    let id = 'imid0';
    //ingestImage(id);


    var iter_num = 1000000;
    console.log('\ntx num: %s', iter_num)

    var exec_min_ms = 1000000;
    var exec_max_ms = -1;
    var exec_total_ms = 0;

    var start = new Date().getTime();

    let i;
    for (i=1;i<=iter_num;i++){
        let time_ms = await queryImage(id);
        exec_total_ms += time_ms;
        if (exec_min_ms>time_ms){
            exec_min_ms = time_ms;
        }
        if (exec_max_ms<time_ms){
            exec_max_ms = time_ms;
        }
        if (i==iter_num){
            console.log('\n(last tx) exec ms: %s', time_ms)
        }
    }
    var response_time_ms = new Date().getTime() - start;

    console.log('\nmin ms: %s\nmax: %s\navg ms: %s\ntotal ms: %s\nresponse ms: %s\n',
            exec_min_ms,exec_max_ms,exec_total_ms/iter_num,exec_total_ms, response_time_ms);

    console.log('----------------------------------');
}


async function ingestImage(id) {

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
                args: [id, image_base64],
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


function queryImage(id) {

    let peerName = channel.getChannelPeer(PEER_NAME)

    async function submit() {
        

       let request = {
            targets: peerName,
            chaincodeId: 'contract_mnist_rat',
            fcn: 'queryImage',
            args: [id]
        };


        // send the query proposal to the peer
        let t = new Date().getTime();
        let response = await channel.queryByChaincode(request);
        let t2 = new Date().getTime();

        let result = JSON.parse(response);
        result.time_interval = t2 - t;

        //console.log(result);

       return result
    }

    return submit().then((result)=>{//console.log(result);
                            return result.time_interval;
                            }).catch((err)=>{console.log(err); return -1});
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