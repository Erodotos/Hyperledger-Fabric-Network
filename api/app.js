//  api work only with node version 8.13.0

const express = require('express');
const bodyParser = require('body-parser')

//Import routes
const utilRoute = require('./routes/util.js');
const invokeRoute = require('./routes/invoke.js')

//Create API using the express framework
const app = express();

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

//This is the API entry point
app.use('/api', utilRoute);
app.use('/api', invokeRoute);

app.listen(8080 , () => {
    console.log('REST-API server running on port 8080');
});

