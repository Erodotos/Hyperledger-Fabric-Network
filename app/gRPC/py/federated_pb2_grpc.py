# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
"""Client and server classes corresponding to protobuf-defined services."""
import grpc

import federated_pb2 as federated__pb2


class ServerStub(object):
    """python -m grpc_tools.protoc   -I.. --python_out=. --grpc_python_out=.   ../msgs_services.proto   (for generating the python files)

    """

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.GetTransactionData = channel.unary_unary(
                '/Server/GetTransactionData',
                request_serializer=federated__pb2.TransactionRequest.SerializeToString,
                response_deserializer=federated__pb2.TransactionReply.FromString,
                )


class ServerServicer(object):
    """python -m grpc_tools.protoc   -I.. --python_out=. --grpc_python_out=.   ../msgs_services.proto   (for generating the python files)

    """

    def GetTransactionData(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_ServerServicer_to_server(servicer, server):
    rpc_method_handlers = {
            'GetTransactionData': grpc.unary_unary_rpc_method_handler(
                    servicer.GetTransactionData,
                    request_deserializer=federated__pb2.TransactionRequest.FromString,
                    response_serializer=federated__pb2.TransactionReply.SerializeToString,
            ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
            'Server', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))


 # This class is part of an EXPERIMENTAL API.
class Server(object):
    """python -m grpc_tools.protoc   -I.. --python_out=. --grpc_python_out=.   ../msgs_services.proto   (for generating the python files)

    """

    @staticmethod
    def GetTransactionData(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/Server/GetTransactionData',
            federated__pb2.TransactionRequest.SerializeToString,
            federated__pb2.TransactionReply.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)