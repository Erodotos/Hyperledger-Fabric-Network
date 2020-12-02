#!/bin/bash

source scriptUtils.sh

# import utils
. scripts/envVar.sh

FABRIC_CFG_PATH=$PWD/config/

CHANNEL_NAME=$1
CC_NAME=$2

write() {
    
    peer chaincode invoke -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    -c '{"function": "writeRoundData","Args": ["id_1", "timestamp", "round", "server_state", "sampled_train_data", "clients_participated", "broadcasted_bits", "aggregated_bits"]}'
    
}

query(){
    
    peer chaincode invoke -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    -c '{"function": "queryRoundData","Args": ["id_1"]}'
}


# write
 query
