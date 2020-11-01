from concurrent.futures import ThreadPoolExecutor

import grpc
import random

from network_test_pb2 import TransactionReply
from network_test_pb2_grpc import ServerServicer
from network_test_pb2_grpc import add_ServerServicer_to_server



class Server(ServerServicer):
    def GetTransactionData(self, request, context):
        return TransactionReply(meas_info=str(random.randint(10000000,90000000)),
                            counter=str(random.randint(10000000,90000000)),
                            cell_name='8424bf520db261335d52a0b827a78538',
                            value=str(random.randint(0,100)))


if __name__ == '__main__':
    server = grpc.server(ThreadPoolExecutor()) #thread pool used to run requests in parallel
    add_ServerServicer_to_server(Server(), server)
    server.add_insecure_port('[::]:9999')
    server.start()
    print('server ready on port 9999')
    server.wait_for_termination()