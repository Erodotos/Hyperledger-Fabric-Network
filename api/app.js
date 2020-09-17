const express = require('express');
const bodyParser = require('body-parser')

//Import routes
const utilRoute = require('./routes/util.js');

//Create API using the express framework
const app = express();

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

//This is the API entry point
app.use('/api', utilRoute);

app.listen(3000 , () => {
    console.log('REST-API server running on port 3000');
});

