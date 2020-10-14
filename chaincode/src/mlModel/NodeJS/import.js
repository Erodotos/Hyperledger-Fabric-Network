const tf = require('@tensorflow/tfjs-node');

//  nodejs v14.13.1
//  nvm v0.36.0
//  npm v6.14.8

//  npm install @tensorflow/tfjs-node
//  npm rebuild @tensorflow/tfjs-node --build-from-source
//  node import.js


function handleSuccess(value){
    console.log(value);

    /*
    (async () => {
        const ed = await tf.io.encodeWeights(value);
    
        return ed;
    })(value).then(handleSuccess2,handleFailure);
    */

    return value;
}

function handleSuccess2(value){
    return console.log(value);
}

function handleFailure(reason){
    return console.log(reason);
}



const MODEL_PATH = 'file://./saved_model/model.json';


var model = (async () => {
    const m =  await tf.loadLayersModel(MODEL_PATH); 

    return m;
})().then(handleSuccess,handleFailure);






