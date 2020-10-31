from concurrent.futures import ThreadPoolExecutor

import grpc

from msgs_services_pb2 import HelloReply #the response type
from msgs_services_pb2_grpc import GreeterServicer #the class to inherit from and override the functions of
from msgs_services_pb2_grpc import add_GreeterServicer_to_server #function to create an gRPC server



class GreeterServer(GreeterServicer):
    def SayHello(self, request, context):
        greeting = "Hello " + request.name + "!"
        return HelloReply(message=greeting)



if __name__ == '__main__':
    server = grpc.server(ThreadPoolExecutor()) #thread pool used to run requests in parallel
    add_GreeterServicer_to_server(GreeterServer(), server)
    server.add_insecure_port('[::]:9999')
    server.start()
    print('server ready on port 9999')
    server.wait_for_termination()