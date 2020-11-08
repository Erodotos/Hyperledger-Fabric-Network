var PROTO_PATH = '../federated.proto';
var grpc = require('grpc');
var protoLoader = require('@grpc/proto-loader');
var packageDefinition = protoLoader.loadSync(
    PROTO_PATH,
    {keepCase: true,
     longs: String,
     enums: String,
     defaults: true,
     oneofs: true
    });
var protoDescriptor = grpc.loadPackageDefinition(packageDefinition);
var client = new protoDescriptor.Server('0.0.0.0:9999', grpc.credentials.createInsecure())

var base_timestamp = 201601251930

async function submitTransaction() {
  
  client.GetTransactionData({name: 'none'}, function(err, tx){
    if(err) {
      console.error(err)
    }else{
      const timestamp = base_timestamp++
      const request = {
            contractId: 'contract_rawOne',
            contractFunction: 'write',
            invokerIdentity: 'Admin@org1.example.com',
            contractArguments: [tx.round, tx.server_state, tx.sampled_train_data, tx.clients_participated, timestamp],
            readOnly: false
      };
      async function submit(){
        console.log(request)
      }
      submit().then(()=>{}).catch((err)=>{console.log(err)});
    }
  })
  
}

submitTransaction().then(()=>{}).catch((err)=>{console.log(err)});


/*
real    1m39,431s
user    0m20,578s
sys     0m7,589s
*/

