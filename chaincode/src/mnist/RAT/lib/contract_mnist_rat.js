'use strict';

const { Contract } = require('fabric-contract-api');


class contract_mnist_rat extends Contract {

    async Init(ctx) {
        
    }

    async writeImage(ctx, image_id, image_base64) {

        const Image = {
            ImageId: image_id,
            ImageBase64: image_base64,
        };

        return ctx.stub.putState(image_id, Buffer.from(JSON.stringify(Image)));

    }

    // ReadAsset returns the asset stored in the world state with given id.
    async queryImage(ctx, image_id) {

        const Image = await ctx.stub.getState(image_id);
        if (!Image || Image.length === 0) {
            throw new Error(`The Image ${image_id} does not exist`);
        }

        var record = JSON.parse(Image)
    
        return JSON.stringify(record);
    }

}

module.exports = contract_mnist_rat;