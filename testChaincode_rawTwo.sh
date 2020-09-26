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
    CC_NAME="contract_rawTwo"
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
        -c '{"function": "WriteBatch", "Args":["[{\"counter\":1,\"cell_name\":\"8424bf520db261335d52a0b827a78538\",\"value\":4863,\"timestamp\":201512200000},{\"counter\":6,\"cell_name\":\"8424bf520db261335d52a0b827a78538\",\"value\":268,\"timestamp\":201512201000}]", "dummy_meas_info", "202109211012"]}'
}

WriteBatch(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_rawTwo"
    setGlobalsForPeer0Org1

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "WriteBatch", "Args":["[{\"value\":1234,\"timestamp\":201512200000},{\"value\":345,\"timestamp\":201512201000}]", "test_info", "1", "202109211010"]}'
}

QueryBatchRangeWithPagination(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_rawTwo"
    setGlobalsForPeer0Org1

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"Args":["QueryBatchRangeWithPagination", "{\"selector\":{\"_id\":{\"$regex\":\"^test_info_1\"}}}","1","", "0", "201512200001"]}'
        

}


WriteBatchComposite(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_rawTwo"
    setGlobalsForPeer0Org1

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
    CHANNEL_NAME=mychannel
    CC_NAME="contract_rawTwo"
    setGlobalsForPeer0Org1

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

#init
#WriteBatch
#QueryBatchRangeWithPagination
#WriteBatchComposite
#QueryBatchRangeComposite