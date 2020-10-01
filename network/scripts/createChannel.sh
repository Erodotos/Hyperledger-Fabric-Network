#!/bin/bash

source scriptUtils.sh

CHANNEL_NAME="$1"
: ${CHANNEL_NAME:="mychannel"}


# import utils
. scripts/envVar.sh

if [ ! -d "channel-artifacts" ]; then
    mkdir channel-artifacts
fi

createChannelTx() {
    
    set -x
    configtxgen -profile BasicChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
        fatalln "Failed to generate channel configuration transaction..."
    fi

    successln "Success on generating channels transaction"
}

createAncorPeerTx() {
    
    for orgmsp in Org1MSP Org2MSP; do
        
        set -x
        configtxgen -profile BasicChannel -outputAnchorPeersUpdate ./channel-artifacts/${orgmsp}anchors.tx -channelID $CHANNEL_NAME -asOrg ${orgmsp} >&log.txt
        res=$?
        { set +x; } 2>/dev/null
        if [ $res -ne 0 ]; then
            fatalln "Failed to generate anchor peer update transaction for ${orgmsp}..."
        fi
    done
    
    successln "Success on generating anchor peer transaction"
}

createChannel() {
    setGlobals 1 0
    
    local rc=1
    local COUNTER=1
    local MAX_RETRY=5
    while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
        sleep 3
        set -x
        peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.example.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA >&log.txt
        res=$?
        { set +x; } 2>/dev/null
        let rc=$res
        COUNTER=$(expr $COUNTER + 1)
    done
    
    verifyResult $res "Channel creation failed"
    successln "Channel '$CHANNEL_NAME' created"
}

joinChannel() {
    ORG=$1
    PEER=$2
    setGlobals $ORG $PEER
    
    local rc=1
    local COUNTER=1
    local MAX_RETRY=5
    while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
        sleep 3
        set -x
        peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block >&log.txt
        res=$?
        { set +x; } 2>/dev/null
        let rc=$res
        COUNTER=$(expr $COUNTER + 1)
    done
    
    verifyResult $res "peer${PEER}.org${ORG} has failed to join channel '$CHANNEL_NAME' "
    successln "peer${PEER}.org${ORG} has joined the channel  '$CHANNEL_NAME'"
}

updateAnchorPeers() {
    ORG=$1
    PEER=$2
    setGlobals $ORG $PEER
    
    local rc=1
    local COUNTER=1
    local MAX_RETRY=5
    while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
        sleep 3
        set -x
        peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile $ORDERER_CA >&log.txt
        res=$?
        { set +x; } 2>/dev/null
        let rc=$res
        COUNTER=$(expr $COUNTER + 1)
    done
    
    verifyResult $res "Anchor peer update failed"
    successln "Anchor peers updated for org '$CORE_PEER_LOCALMSPID' on channel '$CHANNEL_NAME'"
    
}

verifyResult() {
    if [ $1 -ne 0 ]; then
        fatalln "$2"
    fi
}

FABRIC_CFG_PATH=${PWD}/config

## Create channeltx
println ""
infoln "Generating channel create transaction '${CHANNEL_NAME}.tx'"
createChannelTx

## Create anchorpeertx
println ""
infoln "Generating anchor peer update transactions"
createAncorPeerTx

## Create channel
println ""
infoln "Creating channel ${CHANNEL_NAME}"
createChannel

## Join all the peers to the channel
println ""
infoln "Join Org1 peers to the channel..."
joinChannel 1 0
joinChannel 1 1
infoln "Join Org2 peers to the channel..."
joinChannel 2 0
joinChannel 2 1

## Set the anchor peers for each org in the channel
println ""
infoln "Updating anchor peers for org1..."
updateAnchorPeers 1 0
infoln "Updating anchor peers for org2..."
updateAnchorPeers 2 0

println ""
successln "Channel successfully joined"

exit 0