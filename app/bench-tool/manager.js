'use strict';

const { Console } = require('console');
const { exit } = require('process');
const execFile = require('child_process').execFile;


var myArgs = process.argv.slice(2);
var approach = myArgs[0];

var hrstart = process.hrtime()

var organizations = ['org1', 'org2'];
var users = ['Admin'];
var peers = ['0', '1'];
var channel = 'mychannel';
var contract;
if (approach === 'RAT') {
    contract = 'contract_rawOne';
} else if (approach === 'PAT') {
    contract = 'contract_rawTwo';
} else if (approach === 'MAT') {
    contract = 'contract_mlModel';
} else {
    console.log('The given approach is not recognized');
    exit(0);
}



let peerName;
let child;

// console.log("******** EXPERIMENT INFO ********");
// console.log();
// console.log("\tOrganizations : 2");
// console.log("\tPeers per Org : 2");
// console.log("\tBlock_Size : 100 txs");
// console.log();
// console.log("*********************************");

// console.log("\n\n\tSend Rate = 100\n");
// var transactionNumber = 25;

// for (var org of organizations) {
//     for (var peer of peers) {
//         peerName = 'peer' + peer + '.' + org + '.' + 'example.com';
//         console.log(peerName);
//         child = execFile('node', ['test' + approach + '.js', org, users[0], peerName, channel, contract, transactionNumber], (error, stdout, stderr) => {
//             if (error) {
//                 throw error;
//             }
//             console.log(stdout);
//         });
//     }
// }

console.log("\n\n\tSend Rate = 200");
var transactionNumber = 50; //1/4

for (var org of organizations) {
    for (var peer of peers) {
        peerName = 'peer' + peer + '.' + org + '.' + 'example.com';
        child = execFile('node', ['test'+approach+'.js', org, users[0], peerName, channel, contract, transactionNumber], (error, stdout, stderr) => {
            if (error) {
                throw error;
            }
            console.log(stdout);
        });
    }
}

// console.log("\n\n\tSend Rate = 400");
// var transactionNumber = 100;

// for (var org of organizations) {
//     for (var peer of peers) {
//         peerName = 'peer' + peer + '.' + org + '.' + 'example.com';
//         child = execFile('node', ['test'+approach+'.js', org, users[0], peerName, channel, contract, transactionNumber], (error, stdout, stderr) => {
//             if (error) {
//                 throw error;
//             }
//             console.log(stdout);
//         });
//     }
// }

// console.log("\n\n\tSend Rate = 800");
// var transactionNumber = 200;

// for (var org of organizations) {
//     for (var peer of peers) {
//         peerName = 'peer' + peer + '.' + org + '.' + 'example.com';
//         child = execFile('node', ['test'+approach+'.js', org, users[0], peerName, channel, contract, transactionNumber], (error, stdout, stderr) => {
//             if (error) {
//                 throw error;
//             }
//             console.log(stdout);
//         });
//     }
// }

// console.log("\n\n\tSend Rate = 1600");
// var transactionNumber = 400;

// for (var org of organizations) {
//     for (var peer of peers) {
//         peerName = 'peer' + peer + '.' + org + '.' + 'example.com';
//         child = execFile('node', ['test'+approach+'.js', org, users[0], peerName, channel, contract, transactionNumber], (error, stdout, stderr) => {
//             if (error) {
//                 throw error;
//             }
//             console.log(stdout);
//         });
//     }
// }