'use strict';

const { Contract } = require('fabric-contract-api');


class contract_mnist_mat extends Contract {

    async Init(ctx) {
        
    }

    async writeRoundData(ctx, id, timestamp, round, server_state, sampled_train_data, clients_participated, broadcasted_bits, aggregated_bits) {

        const Mnist_Round_Data = {
            timestamp: timestamp,
            round: round,
            server_state: server_state,
            sampled_train_data: sampled_train_data,
            clients_participated: clients_participated,
            broadcasted_bits: broadcasted_bits,
            aggregated_bits: aggregated_bits,
        };

        return ctx.stub.putState(id, Buffer.from(JSON.stringify(Mnist_Round_Data)));

    }

    // ReadAsset returns the asset stored in the world state with given id.
    async queryRoundData(ctx, id) {

        const Mnist_Round_Data = await ctx.stub.getState(id);
        if (!Mnist_Round_Data || Mnist_Round_Data.length === 0) {
            throw new Error(`The Model ${id} does not exist`);
        }

        var record = JSON.parse(Mnist_Round_Data)
    
        return JSON.stringify(record);
    }

}

module.exports = contract_mnist_mat;