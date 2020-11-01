'use strict';

const { Contract } = require('fabric-contract-api');


class contract_mlModel extends Contract {

    async Init(ctx) {
        
    }

    async writeModel(ctx, id, model_json, model_weights) {

        const Telco_Model = {
            ID: id,
            Model_Json: model_json,
            Model_Weights: model_weights,
        };

        return ctx.stub.putState(id, Buffer.from(JSON.stringify(Telco_Model)));

    }

    // ReadAsset returns the asset stored in the world state with given id.
    async queryModel(ctx, id) {

        const Telco_Model = await ctx.stub.getState(id);
        if (!Telco_Model || Telco_Model.length === 0) {
            throw new Error(`The Model ${id} does not exist`);
        }

        var record = JSON.parse(Telco_Model)
    
        var model_buffer = new Buffer(record.Model_Json, 'base64');
        var weights_buffer = new Buffer(record.Model_Weights, 'base64');

        return model_buffer.toString();
    }

}

module.exports = contract_mlModel;