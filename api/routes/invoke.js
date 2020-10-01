'use strict';

const express = require('express');
const router = express.Router();

const { FileSystemWallet, Gateway } = require('fabric-network');
const fs = require('fs');
const path = require('path');

const ccpPath = path.resolve(__dirname, '../config/connection_profile.json');
const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

router.post('/invoke/chaincodes/:chaincode/', async function (req, res) {
    
    var fnc = req.body.fnc
    var args = req.body.args
    var user = req.body.user
    var channel = "mychannel"
    var chaincode = req.params.chaincode
    
    try {
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(user);
        if (!userExists) {
            console.log(`An identity for the user ${user} does not exist in the wallet`);
            res.send((`An identity for the user ${user} does not exist in the wallet`))
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: user, discovery: { enabled: true, asLocalhost: false } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channel);

        // Get the contract from the network.
        const contract = network.getContract(chaincode);

        if (fnc == "Init"){
            await contract.submitTransaction('Init');
        } else if( fnc == "write"){
            await contract.submitTransaction('write', args.meas_info, args.counter, args.cell_name, args.value, args.timestamp);
        }

        console.log('Transaction has been submitted');
        res.send('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
});    


module.exports = router;