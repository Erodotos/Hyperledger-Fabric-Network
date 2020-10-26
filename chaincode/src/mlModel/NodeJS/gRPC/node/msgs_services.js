//dynamic generation of service descriptors and client stub definitions
const grpc = require('grpc')
const proto = grpc.load({file: 'msgs_services.proto', root: `..`})
const client = new proto.Greeter('localhost:9999', grpc.credentials.createInsecure())

client.SayHello({name: 'World'}, function(err, msg){
    if(err) {
      console.error(err)
    }
    console.log(msg)
  })

