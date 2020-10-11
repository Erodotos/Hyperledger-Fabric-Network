import * as tf from '@tensorflow/tfjs';

//To use the 'import' statement with Node.js:
//  npm install @tensorflow/tfjs
//  npm install --save esm
//  node -r esm filename.js  (run)


function handleSuccess(value){
    return console.log(value.toJSON().toString());
}

function handleFailure(reason){
    return console.log(reason);
}


//loadLayersModel supports only HTTP(S) proto
//(It also needs the input/batch shape attribute of the first hidden layer to be declared; not figured out dynamically.)
//Used a dummy site of mine to get the models with http;
//might be efficient to have a server.js initiated on a machine to return the model files to the node.js script
const HTTP_MODEL_PATH = 'https://skoumo01.github.io/json_files/saved_model/model.json'; 


const model = (async () => {
    return await tf.loadLayersModel(HTTP_MODEL_PATH); 
})().then(handleSuccess,handleFailure);





