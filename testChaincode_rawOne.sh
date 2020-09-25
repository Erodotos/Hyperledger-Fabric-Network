#!/bin/bash

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/certificates/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/certificates/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/certificates/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/configurations


setGlobalsForOrderer(){
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/certificates/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/certificates/ordererOrganizations/example.com/users/Admin@example.com/msp
    
}

setGlobalsForPeer0Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/certificates/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/certificates/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
}

setGlobalsForPeer0Org2(){
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/certificates/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
}

setGlobalsForPeer1Org2(){
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/certificates/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
    
}

init(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_rawOne"
    setGlobalsForPeer0Org1

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --isInit \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "Init","Args": []}'
}

write(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_rawOne"
    setGlobalsForPeer0Org1

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "write","Args": ["50331648", "50331662", "8424bf520db261335d52a0b827a78538", "4000", "201512200045"]}'
}

queryRecords(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_rawOne"
    setGlobalsForPeer0Org1

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "queryRecords","Args": ["{\"selector\":{\"_id\" : {\"$eq\" : \"50331648_50331654\"}}}"]}'
}

queryRecordsWithPagination(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_rawOne"
    setGlobalsForPeer0Org1

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "queryRecordsWithPagination","Args": ["{\"selector\":{\"timestamp\" : {\"$gt\" : 0}}}", "3", ""]}'
}


getRecordHistory(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_rawOne"
    setGlobalsForPeer0Org1

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "getRecordHistory","Args": ["50331648_50331654"]}'
}



# init
# write
# queryRecords
# queryRecordsWithPagination
# getRecordHistory