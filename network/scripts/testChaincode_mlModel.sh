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
    -c '{"function": "writeModel","Args": ["id_1", "'"$model"'", "'"$weights"'"]}'
    
}


queryRecords(){
    
    peer chaincode invoke -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME \
    -n ${CC_NAME}  \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    -c '{"function": "queryModel","Args": ["id_1"]}'
}

model=$(<../chaincode/src/mlModel/NodeJS/saved_model/model_base64)
weights=$(<../chaincode/src/mlModel/NodeJS/saved_model/weights_base64)

# write
queryRecords
