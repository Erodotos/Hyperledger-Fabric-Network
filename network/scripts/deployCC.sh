#!/bin/bash

source scriptUtils.sh

# import utils
. scripts/envVar.sh

FABRIC_CFG_PATH=$PWD/config/

CHANNEL_NAME=${1:-"mychannel"}
CC_NAME=${2:-"rawOne"}
CC_SRC_LANGUAGE=${3:-"golang"}
CC_SRC_PATH=${4:-"/chaincode/src/rawOne/"}
CC_VERSION=${5:-"1.0"}

# do some language specific preparation to the chaincode before packaging
vendorGoDependencies(){
    infoln "Vendoring Go dependencies at $CC_SRC_PATH"
    pushd $CC_SRC_PATH
    GO111MODULE=on go mod vendor
    popd
    successln "Finished vendoring Go dependencies"
}

packageChaincode() {
    ORG=$1
    PEER=$2
    setGlobals $ORG $PEER
    
    set -x
    peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_SRC_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    cat log.txt
    verifyResult $res "Chaincode packaging on peer0.org${ORG} has failed"
    successln "Chaincode is packaged on peer0.org${ORG}"
}

# installChaincode PEER ORG
installChaincode() {
    ORG=$1
    PEER=$2
    setGlobals $ORG $PEER
    
    set -x
    peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    
    
    verifyResult $res "Chaincode installation on peer0.org${ORG} has failed"
    successln "Chaincode is installed on peer0.org${ORG}"
}

# queryInstalled PEER ORG
queryInstalled() {
    ORG=$1
    PEER=$2
    setGlobals $ORG $PEER
    
    set -x
    peer lifecycle chaincode queryinstalled >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    verifyResult $res "Query installed on peer${PEER}.org${ORG} has failed"
    successln "Query installed successful on peer${PEER}.org${ORG} on channel"
}

# approveForMyOrg VERSION PEER ORG
approveForMyOrg() {
    ORG=$1
    PEER=$2
    setGlobals $ORG $PEER
    
    set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --package-id ${PACKAGE_ID} \
    --init-required \
    --sequence ${CC_VERSION} >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    
    verifyResult $res "Chaincode definition approved on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME' failed"
    successln "Chaincode definition approved on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME'"
}

# checkCommitReadiness VERSION PEER ORG
checkCommitReadiness() {
    ORG=$1
    PEER=$2
    setGlobals $ORG $PEER
    
    infoln "Checking the commit readiness of the chaincode definition on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME'..."
    
    set -x
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
    --name ${CC_NAME} --version ${CC_VERSION} \
    --sequence ${CC_VERSION}  --init-required \
    --output json >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    
    infoln "Checking the commit readiness of the chaincode definition successful on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME'"
}

commitChaincodeDefinition() {
    parsePeerConnectionParameters $@
    res=$?
    verifyResult $res "Invoke transaction failed on channel '$CHANNEL_NAME' due to uneven number of peer and org parameters "
    
    set -x
    peer lifecycle chaincode commit -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME \
    --name ${CC_NAME} \
    $PEER_CONN_PARMS \
    --version ${CC_VERSION} --sequence ${CC_VERSION} \
    --init-required >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    
    verifyResult $res "Chaincode definition commit failed on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME' failed"
    successln "Chaincode definition committed on channel '$CHANNEL_NAME'"
    
}

# queryCommitted ORG
queryCommitted() {
    ORG=$1
    PEER=0
    setGlobals $ORG $PEER
    
    infoln "Querying chaincode definition on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME'..."
    
    set -x
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME} >&log.txt
    res=$?
    { set +x; } 2>/dev/null
}

chaincodeInvokeInit() {
    parsePeerConnectionParameters $@
    res=$?
    verifyResult $res "Invoke transaction failed on channel '$CHANNEL_NAME' due to uneven number of peer and org parameters "
    
    # while 'peer chaincode' command can get the orderer endpoint from the
    # peer (if join was successful), let's supply it directly as we know
    # it using the "-o" option
    set -x
    fcn_call='{"function":"Init","Args":[]}'
    infoln "invoke fcn call:${fcn_call}"
    
    peer chaincode invoke -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA -C $CHANNEL_NAME \
    -n ${CC_NAME} $PEER_CONN_PARMS \
    --isInit -c ${fcn_call} >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    
    verifyResult $res "Invoke execution on $PEERS failed "
    successln "Invoke transaction successful on $PEERS on channel '$CHANNEL_NAME'"
}

## package the chaincode
infoln "Packaging chaincode on Org1 Peer0"
packageChaincode 1 0 

## Install chaincode on peer0.org1, peer1.org1 and peer0.org2, peer1.org2
infoln "Installing chaincode on Org1"
installChaincode 1 0
installChaincode 1 1
infoln "Installing chaincode on Org2"
installChaincode 2 0
installChaincode 2 1

## query whether the chaincode is installed
queryInstalled 1 0
queryInstalled 1 1
queryInstalled 2 0
queryInstalled 2 1

## approve the definition for org1
approveForMyOrg 1 0

## check whether the chaincode definition is ready to be committed
## expect org1 to have approved and org2 not to
checkCommitReadiness 1 0
checkCommitReadiness 2 0

## now approve also for org2
approveForMyOrg 2 0

## check whether the chaincode definition is ready to be committed
## expect them both to have approved
checkCommitReadiness 1 0
checkCommitReadiness 2 0

## now that we know for sure both orgs have approved, commit the definition
infoln "Commiting chaincode on Org1 and Org2"
commitChaincodeDefinition 1 2

## query on both orgs to see that the definition committed successfully
queryCommitted 1
queryCommitted 2

# Init Chaincode
chaincodeInvokeInit 1 2

exit 0