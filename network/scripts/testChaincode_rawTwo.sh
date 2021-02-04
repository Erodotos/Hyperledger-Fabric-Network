#!/bin/bash

source scriptUtils.sh

# import utils
. scripts/envVar.sh

FABRIC_CFG_PATH=$PWD/config/

CHANNEL_NAME=$1
CC_NAME=$2


WriteBatch(){

    peer chaincode invoke -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    -c '{"function": "WriteBatch", "Args":["[{\"value\":1234,\"timestamp\":201512200000},{\"value\":345,\"timestamp\":201512200001},{\"value\":345,\"timestamp\":201512200002},{\"value\":345,\"timestamp\":201512200003},{\"value\":345,\"timestamp\":201512200004}]", "test_info", "1", "201512200000"]}'
    #-c '{"function": "WriteBatch", "Args":["[{\"value\":1234,\"timestamp\":201512200005},{\"value\":345,\"timestamp\":201512200006},{\"value\":345,\"timestamp\":201512200007},{\"value\":345,\"timestamp\":201512200008},{\"value\":345,\"timestamp\":201512200009}]", "test_info", "1", "201512200005"]}'
    #-c '{"function": "WriteBatch", "Args":["[{\"value\":345,\"timestamp\":201512200010},{\"value\":345,\"timestamp\":201512200011},{\"value\":345,\"timestamp\":201512200012},{\"value\":345,\"timestamp\":201512200013},{\"value\":1234,\"timestamp\":201512200014}]", "test_info", "1", "201512200010"]}'

}

QueryBatchRangeWithPagination(){

    peer chaincode invoke -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    -c '{"Args":["QueryBatchRangeWithPagination", "{\"selector\":{\"_id\":{\"$regex\":\"^test_info_1\"}},\"use_index\":[\"_design/indexID\", \"indexID\"]}","1","", "201512200003", "201512200008"]}'     
}


WriteBatchComposite(){

    peer chaincode invoke -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    -c '{"function": "WriteBatchComposite", "Args":["[{\"value\":345,\"timestamp\":201512200010},{\"value\":345,\"timestamp\":201512200011},{\"value\":345,\"timestamp\":201512200012},{\"value\":345,\"timestamp\":201512200013},{\"value\":1234,\"timestamp\":201512200014}]", "test_info", "1", "201512200010"]}'
    #-c '{"function": "WriteBatchComposite", "Args":["[{\"value\":1234,\"timestamp\":201512200000},{\"value\":345,\"timestamp\":201512200001},{\"value\":345,\"timestamp\":201512200002},{\"value\":345,\"timestamp\":201512200003},{\"value\":345,\"timestamp\":201512200004}]", "test_info", "1", "201512200000"]}'
    #-c '{"function": "WriteBatchComposite", "Args":["[{\"value\":1234,\"timestamp\":201512200005},{\"value\":345,\"timestamp\":201512200006},{\"value\":345,\"timestamp\":201512200007},{\"value\":345,\"timestamp\":201512200008},{\"value\":345,\"timestamp\":201512200009}]", "test_info", "1", "201512200005"]}'
}

QueryBatchRangeComposite(){

    peer chaincode invoke -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    -c '{"Args":["QueryBatchRangeComposite", "test_info", "1", "201512200003", "201512200012", "5"]}'

}


#Shim-API: Raw II Chaincode

WriteBatch
#QueryBatchRangeWithPagination

#WriteBatchComposite
#QueryBatchRangeComposite