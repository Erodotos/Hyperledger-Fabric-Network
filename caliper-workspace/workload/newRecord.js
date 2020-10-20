'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');
var base_timestamp = 201601251930

class MyWorkload extends WorkloadModuleBase {
    constructor() {
        super();
    }
    
    async submitTransaction() {
        const meas_info = (Math.floor(10000000 + Math.random() * 90000000)).toString()
        const counter = (Math.floor(10000000 + Math.random() * 90000000)).toString()
        const cell_name = "8424bf520db261335d52a0b827a78538"
        const value = (Math.floor(Math.random()*100)).toString()
        const timestamp = base_timestamp++
        const request = {
            contractId: 'contract_rawOne',
            contractFunction: 'write',
            invokerIdentity: 'Admin@org1.example.com',
            contractArguments: [meas_info, counter, cell_name, value, timestamp],
            readOnly: false
        };

        await this.sutAdapter.sendRequests(request);
    }
    
}

function createWorkloadModule() {
    return new MyWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;