const FabricCAServices = require('fabric-ca-client');
const { Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');

const ccpPath = path.resolve(__dirname, './config/connection_profile.json');
const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

const wallet = Wallets.newFileSystemWallet("./wallet");
