'use strict';

const { Contract } = require('fabric-contract-api');

class contract_mlModel extends Contract {

    async InitLedger(ctx) {
        
    }

    // CreateAsset issues a new asset to the world state with given details.
    async writeModel(ctx, id, location, model) {
        const Telco_Model = {
            ID: id,
            Location: location,
            Model: model,
        };
        return ctx.stub.putState(id, Buffer.from(JSON.stringify(Telco_Model)));
    }

    // ReadAsset returns the asset stored in the world state with given id.
    async queryModel(ctx, id) {
        const assetJSON = await ctx.stub.getState(id); // get the asset from chaincode state
        if (!assetJSON || assetJSON.length === 0) {
            throw new Error(`The asset ${id} does not exist`);
        }
        return assetJSON.toString();
    }

}

module.exports = contract_mlModel;