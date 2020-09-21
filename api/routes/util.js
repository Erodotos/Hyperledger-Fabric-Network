'use strict';

const express = require('express');
const router = express.Router();

const FabricCAServices = require('fabric-ca-client');
const { FileSystemWallet, Gateway, X509WalletMixin } = require('fabric-network');
const fs = require('fs');
const path = require('path');

const ccpPath = path.resolve(__dirname, '../config/connection_profile.json');
const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

//Register a new admin providing admin name and password
router.post("/util/registerAdmin", async (req, res) => {

    // this need to be fixed. Fabric wont accept other than these
    //input data for admin name and password
    var adminName = "admin"
    var password = "adminpw"

    try {
        // Create a new CA client for interacting with the CA.
        const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
        const ca = new FabricCAServices(caURL);

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the admin user.
        const adminExists = await wallet.exists(adminName);
        if (adminExists) {
            console.log('An identity for the admin user \"', adminName, '\" already exists in the wallet');
            res.send('An identity for the admin user \"', adminName, '\" already exists in the wallet')
        }

        // Enroll the admin user, and import the new identity into the wallet.
        const enrollment = await ca.enroll({ enrollmentID: adminName, enrollmentSecret: password });
        const identity = X509WalletMixin.createIdentity('Org1MSP', enrollment.certificate, enrollment.key.toBytes());
        wallet.import(adminName, identity);
        console.log('Successfully enrolled admin user \"', adminName, '\" and imported it into the wallet');
        res.send(identity);
    } catch (error) {
        console.log(error);
        res.send(`Failed to enroll admin user ${adminName} : ${error}`);
    }
});

//This function need to be reversed to an old version fabric-network for compatibility
router.post("/util/registerUser", async (req, res) => {

    var adminName = req.body.admin
    var username = req.body.username

    try {
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(username);
        if (userExists) {
            console.log(`An identity for the user ${username} already exists in the wallet`);
            res.send(`An identity for the user ${username} already exists in the wallet`);
        }

        // Check to see if we've already enrolled the admin user.
        const adminExists = await wallet.exists(adminName);
        if (!adminExists) {
            console.log(`An identity for the admin user ${adminName} does not exist in the wallet`);
            console.log('Run the enrollAdmin.js application before retrying');
            res.send(`An identity for the admin user ${adminName} does not exist in the wallet`)
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: adminName, discovery: { enabled: false } });

        // Get the CA client object from the gateway for interacting with the CA.
        const ca = gateway.getClient().getCertificateAuthority();
        const adminIdentity = gateway.getCurrentIdentity();

        // Register the user, enroll the user, and import the new identity into the wallet.
        const secret = await ca.register(
            {
                affiliation: 'org1.department1',
                enrollmentID: username,
                role: 'client'
            },
            adminIdentity
        );

        const enrollment = await ca.enroll({ enrollmentID: username, enrollmentSecret: secret });
        const userIdentity = X509WalletMixin.createIdentity('Org1MSP', enrollment.certificate, enrollment.key.toBytes());
        wallet.import(username, userIdentity);
        console.log(`Successfully registered and enrolled admin user ${username} and imported it into the wallet`);
        res.send(userIdentity);
    } catch (error) {
        console.log(error)
        res.send(`Failed to register user ${username} : ${error}`);
    }
});

router.get("/util/ping", (req, res) => {
    res.send("API is running")
});

module.exports = router;