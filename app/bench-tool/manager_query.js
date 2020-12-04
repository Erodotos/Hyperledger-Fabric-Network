'use strict';

const { exit } = require('process');
const execFile = require('child_process').execFile;


var myArgs = process.argv.slice(2);
var approach = myArgs[0];
var multipeer = myArgs[1];
var totaltransactionNumber = myArgs[2];

if (!totaltransactionNumber){
    console.log('Number of transactions unspecified.');
    exit(0);
}

var peerNumber = 4;
var channel = 'mychannel';
var organizations;
var users;
var peers;
var transactionNumber;
if (multipeer === 'true'){
    organizations = ['org1', 'org2'];
    users = ['Admin'];
    peers = ['0', '1'];
    transactionNumber = totaltransactionNumber/peerNumber;
}else if(multipeer === 'false'){
    organizations = ['org1'];
    users = ['Admin'];
    peers = ['0'];
    transactionNumber = totaltransactionNumber;
}else{
    console.log('Multipeer parameter not specified.');
    exit(0);
}


var contract;
if (approach === 'RAT') {  
    contract = 'contract_mnist_rat';
} else if (approach === 'MAT') {
    contract = 'contract_mnist_mat';
} else {
    console.log('The given approach is not recognized.');
    exit(0);
}

let peerName;
let child;

console.log("\n\tTotal Transaction Number:\t\t", totaltransactionNumber);

var sum_of_peer_execution_time = 0;
var iteration_count = 0;
for (var org of organizations) {
    for (var peer of peers) {
        peerName = 'peer' + peer + '.' + org + '.' + 'example.com';
        child = execFile('node', ['test'+approach+'_query.js', org, users[0], peerName, channel, contract, transactionNumber], (error, stdout, stderr) => {
            if (error) {
                throw error;
            }
            
            let temp = stdout.toString().split(' ');
            sum_of_peer_execution_time += parseFloat((temp[2]+temp[3]).replace(",", "."));
            iteration_count++;
            if (iteration_count===peerNumber){
                let execution_time = sum_of_peer_execution_time/peerNumber;
                let throughput = totaltransactionNumber/execution_time;
                console.log('\tTotal Execution Time (seconds):\t\t', execution_time);
                console.log('\tThroughput (transactions/seconds):\t', throughput,'\n');
            }
        });
    }
}


