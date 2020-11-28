'use strict';

const { exit } = require('process');
const execFile = require('child_process').execFile;


var myArgs = process.argv.slice(2);
var approach = myArgs[0];


var organizations = ['org1', 'org2'];
var users = ['Admin'];
var peers = ['0', '1'];
var channel = 'mychannel';
var contract;
if (approach === 'RAT') {
    contract = 'contract_mnist_rat';
} /*else if (approach === 'MAT') {
    contract = 'contract_mnist_mat';
}*/ else {
    console.log('The given approach is not recognized');
    exit(0);
}

let peerName;
let child;

console.log("\n\n\tQuery Request Rate = 90000");
var transactionNumber = 22500; //1/4

for (var org of organizations) {
    for (var peer of peers) {
        peerName = 'peer' + peer + '.' + org + '.' + 'example.com';
        child = execFile('node', ['test'+approach+'_query.js', org, users[0], peerName, channel, contract, transactionNumber], (error, stdout, stderr) => {
            if (error) {
                throw error;
            }
            console.log(stdout);
        });
    }
}

