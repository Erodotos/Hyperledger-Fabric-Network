from concurrent.futures import ThreadPoolExecutor

import grpc
import random

from federated_pb2 import TransactionReply
from federated_pb2_grpc import ServerServicer
from federated_pb2_grpc import add_ServerServicer_to_server



class Server(ServerServicer):
    def GetTransactionData(self, request, context):
        return TransactionReply(timestamp='timestamp',
                            round='round',
                            server_state='server_state',
                            sampled_train_data='sampled_train_data',
                            clients_participated='clients_participated',
                            broadcasted_bits='broadcasted_bits',
                            aggregated_bits='aggregated_bits')


if __name__ == '__main__':
    server = grpc.server(ThreadPoolExecutor()) #thread pool used to run requests in parallel
    add_ServerServicer_to_server(Server(), server)
    server.add_insecure_port('[::]:9999')
    server.start()
    print('server ready on port 9999')
    server.wait_for_termination()