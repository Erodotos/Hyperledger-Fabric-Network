'use strict';

const { Contract } = require('fabric-contract-api');


const grpc = require('grpc')/////////////////////


class contract_mlModel extends Contract {

    async Init(ctx) {
        const proto = grpc.load({file: 'msgs_services.proto', root: `../gRPC`})
        const client = new proto.Greeter('localhost:9999', grpc.credentials.createInsecure())
        
        client.SayHello({name: 'World'}, function(err, msg){
            if(err) {
              console.error(err)
            }
            console.log(msg)
          })
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