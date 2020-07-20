#!/bin/bash

function createOrgs() {

    # Create crypto material using cryptogen
    echo
    echo "##########################################################"
    echo "##### Generate certificates using cryptogen tool #########"
    echo "##########################################################"
    echo
    
    set -x
    cryptogen generate --config=./configurations/crypto-config.yaml --output="certificates"
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate certificates..."
        exit 1
    fi
}

# Generate orderer system channel genesis block.
function createGenesisBlock() {
    
    echo "#########  Generating Genesis block ##############"
    
    # Note: For some unknown reason (at least for now) the block file can't be
    # named orderer.genesis.block or the orderer will fail to launch!
    set -x
    configtxgen -profile OrdererGenesis -channelID sys-channel -outputBlock ./system-genesis-block/genesis.block
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate orderer genesis block..."
        exit 1
    fi
}

function createChannelConfigBlock(){
    
    echo "#########  Generating Channel configurations block ##############"
    configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./mychannel.tx -channelID mychannel
}

# This is very important to set!!! configtxgen tool use this path to find 
# configuration file
export FABRIC_CFG_PATH=${PWD}/configurations

createOrgs
createGenesisBlock

CHANNEL_NAME=mychannel

# Generate channel configuration block
echo
echo "#########  Generating Genesis block ##############"
configtxgen -profile BasicChannel -outputCreateChannelTx ./mychannel.tx -channelID $CHANNEL_NAME

echo
echo "#######    Generating anchor peer update for Org1MSP  ##########"
configtxgen -profile BasicChannel -outputAnchorPeersUpdate ./Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

echo
echo "#######    Generating anchor peer update for Org2MSP  ##########"
configtxgen -profile BasicChannel -outputAnchorPeersUpdate ./Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP