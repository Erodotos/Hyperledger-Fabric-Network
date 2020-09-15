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
    let adminName = "admin"
    let password = "adminpw"
    
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

    try {
        // Create a new CA client for interacting with the CA.
        const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
        const ca = new FabricCAServices(caURL);

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userIdentity = await wallet.get(req.body.username);
        if (userIdentity) {
            console.log(`An identity for the user : ${req.body.username} already exists in the wallet`);
            res.send(`An identity for the user : ${req.body.username} already exists in the wallet`)
        }

        // Check to see if we've already enrolled the admin user.
        const adminIdentity = await wallet.get(req.body.adminname);
        if (!adminIdentity) {
            console.log(`An identity for the admin user ${req.body.adminname} does not exist in the wallet`);
            res.send(`An identity for the admin user ${req.body.adminname} does not exist in the wallet`)
        }

        // build a user object for authenticating with the CA
        const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
        const adminUser = await provider.getUserContext(adminIdentity, req.body.adminname);

        // Register the user, enroll the user, and import the new identity into the wallet.
        const secret = await ca.register({
            affiliation: 'org1',
            enrollmentID: req.body.username,
            role: 'user-client'
        }, adminUser);

        const enrollment = await ca.enroll({
            enrollmentID: req.body.username,
            enrollmentSecret: secret
        });

        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: 'Org1MSP',
            type: 'X.509',
        };

        await wallet.put(req.body.username, x509Identity);
        console.log(`Successfully registered and enrolled admin user ${req.body.username} and imported it into the wallet`);

        res.send(x509Identity)
    } catch (error) {
        console.error(`Failed to register user ${req.body.username}: ${error}`);
        res.send(error)
    }


});

router.get("/util/health", (req, res) => {
    res.send("API is running")
});



module.exports = router;
