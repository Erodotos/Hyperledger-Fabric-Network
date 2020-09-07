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

createDevice(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_influx_chaincode"
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
        -c '{"function": "CreateDevice","Args":["Dev1", "Warehouse A"]}'

}

queryDevice(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_influx_chaincode"
    setGlobalsForPeer0Org1

    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["QueryDevice", "Dev1"]}'
}

updateDeviceLocation(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_influx_chaincode"
    setGlobalsForPeer0Org1

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "UpdateLocation","Args":["Dev1", "Warehouse C"]}'
}

writeInfluxContract(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_influx_chaincode"
    setGlobalsForPeer0Org1
    
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "WriteToInflux","Args":["{\"points\":[{\"measurement\" : \"stat4\", \"tags\" : [{ \"key\" : \"p1t1\", \"value\" : \"a\"}, { \"key\" : \"p1t2\", \"value\" : \"b\" }],\"fields\" : [{\"key\" : \"p1f1\",\"value\":\"c\"}],\"timestamp\":\"1136239445\"},{\"measurement\":\"stat4\",\"tags\":[{\"key\":\"p2t1\",\"value\":\"a\"},{\"key\":\"p2t2\",\"value\":\"b\"}],\"fields\":[{\"key\":\"p2f1\",\"value\":\"c\"}],\"timestamp\":\"1136239446\"}]}"]}'

   
}


readInfluxContract(){
    CHANNEL_NAME=mychannel
    CC_NAME="contract_influx_chaincode"
    setGlobalsForPeer0Org1
    
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME \
        -n ${CC_NAME}  \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"function": "ReadFromInflux","Args":["mydb", "autogen", "-2h", "-1m", "stat4"]}'
        
        #db, rp, start, stop, measurement 

}


#Contract-API: Influx Chaincode
# createDevice
# queryDevice
# updateDeviceLocation
# writeInfluxContract   #CANNOT be used as --isInit
 readInfluxContract    #CANNOT be used as --isInit

##{"points":[{"measurement" : "stat4", "tags" : [{ "key" : "p1t1", "value" : "a"}, { "key" : "p1t2", "value" : "b" }],"fields" : [{"key" : "p1f1","value":"c"}],"timestamp":"1136239445"},{"measurement":"stat4","tags":[{"key":"p2t1","value":"a"},{"key":"p2t2","value":"b"}],"fields":[{"key":"p2f1","value":"c"}],"timestamp":"1136239446"}]}