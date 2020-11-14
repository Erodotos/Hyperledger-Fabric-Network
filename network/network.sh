export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

source scriptUtils.sh

# Print the usage message
function printHelp() {
    println
    println "Usage: "
    println "  network.sh <Mode> [Flags]"
    println "    Modes:"
    println "      \033[0;32mup\033[0m - bring up fabric orderer and peer nodes. After that create and join a channe;"
    println "      \033[0;32mdown\033[0m - shut down all fabric services and erase channel artifacts"
    println "      \033[0;32mdeployCC\033[0m - deploy a specified chaincode according to the input flags"
    println
    println "    Flags:"
    println "     Used with \033[0;32mnetwork.sh up\033[0m :"
    println "     -c <channel name> - channel name to use (defaults to \"mychannel\")"
    println "     -db <dbtype> - the database backend to use: goleveldb (default) or couchdb"
    println
    println "     Used with \033[0;32mnetwork.sh deployCC\033[0m"
    println "     -c <channel name> - deploy chaincode to channel"
    println "     -ccn <name> - the name of the chaincode to deploy"
    println "     -ccv <version>  - chaincode version."
    println "     -ccp <path>  - Path to the chaincode."
    println
    println "     Used with \033[0;32mnetwork.sh testCC\033[0m"
    println "     -c <channel name> - deploy chaincode to channel"
    println "     -ccn <name> - the short name of the chaincode to deploy"
    println
    println "    -h - print this message"
    println
    println " Examples:"
    println "   network.sh up -c mychannel -db couchdb"
    println "   network.sh deployCC -c mychannel -ccn contract_rawOne -ccv 1 -ccp ../chaincode/src/rawOne/ -ccl golang"
    println "   network.sh testCC -c mychannel -ccn contract_rawOne"
    println "   network.sh down"
    println
}

function cleanFolder() {
    rm -rf ./organizations
    rm ./channel-artifacts/*
    rm -rf ./system-genesis-block/*
    rm log.txt
    rm *.tar.gz
}

function clearContainers() {
    CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /dev-peer.*/) {print $1}')
    if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
        infoln "No containers available for deletion"
    else
        docker rm -f $CONTAINER_IDS
    fi
}

function removeUnwantedImages() {
    DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
    if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
        infoln "No images available for deletion"
    else
        docker rmi -f $DOCKER_IMAGE_IDS
    fi
}

# Create Organization crypto material using cryptogen or CAs
function createOrgs() {
    
    if [ -d "organizations/peerOrganizations" ]; then
        rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
    fi
    
    infoln "Generate certificates using cryptogen tool"
    
    set -x
    cryptogen generate --config=./config/crypto-config.yaml --output="organizations" >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
        fatalln "Failed to generate certificates..."
    fi
}

# Generate orderer system channel genesis block.
function createConsortium() {
    
    infoln "Generating Orderer Genesis block"
    
    set -x
    configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block >&log.txt
    res=$?
    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
        fatalln "Failed to generate orderer genesis block..."
    fi
}

# Bring up the peer and orderer nodes using docker compose.
function networkUp() {
    println ""
    infoln "Bringing up the network ..."
    
    # generate artifacts if they don't exist
    if [ ! -d "organizations/peerOrganizations" ]; then
        createOrgs
        createConsortium
    fi
    
    COMPOSE_FILES="-f ${COMPOSE_FILE_BASE}"
    
    if [ "${DATABASE}" == "couchdb" ]; then
        COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_COUCH}"
    fi
    
    IMAGE_TAG=$IMAGETAG docker-compose ${COMPOSE_FILES} up -d 2>&1
    
    successln "Network is up and running"
    
}

## call the script to join create the channel and join the peers of org1 and org2
function createChannel() {
    
    scripts/createChannel.sh $CHANNEL_NAME
    if [ $? -ne 0 ]; then
        fatalln "Create channel failed"
    fi
}

## Call the script to install and instantiate a chaincode on the channel
function deployCC() {
    
    scripts/deployCC.sh $CHANNEL_NAME $CC_NAME $CC_SRC_LANGUAGE $CC_SRC_PATH $CC_VERSION
    
    if [ $? -ne 0 ]; then
        fatalln "Deploying chaincode failed"
    fi
    
    exit 0
}

function networkDown() {
    infoln "Bringing network down and cleaning the folder ..."
    docker-compose -f $COMPOSE_FILE_BASE -f $COMPOSE_FILE_COUCH -f $COMPOSE_FILE_CA down --volumes --remove-orphans
    clearContainers
    removeUnwantedImages
    cleanFolder
}

# Default Values
CHANNEL_NAME="mychannel"
CC_NAME="contract_rawOne"
CC_SRC_PATH="../chaincode/src/rawOne/"
IMAGETAG="latest"

# use this as the default docker-compose yaml definition
COMPOSE_FILE_BASE=docker/docker-compose.yaml
# docker-compose.yaml file if you are using couchdb
COMPOSE_FILE_COUCH=docker/docker-compose-couch.yaml
# certificate authorities compose file
COMPOSE_FILE_CA=docker/docker-compose-ca.yaml
# this is the default chaincode language
CC_SRC_LANGUAGE="golang"

## Parse mode
if [[ $# -lt 1 ]] ; then
    printHelp
    exit 0
else
    MODE=$1
    shift
fi

# parse flags
while [[ $# -ge 1 ]] ; do
    key="$1"
    case $key in
        -h )
            printHelp
            exit 0
        ;;
        -c )
            CHANNEL_NAME="$2"
            shift
        ;;
        -db )
            DATABASE="$2"
            shift
        ;;
        -ccn )
            CC_NAME="$2"
            shift
        ;;
        -ccv )
            CC_VERSION="$2"
            shift
        ;;
        -ccp )
            CC_SRC_PATH="$2"
            shift
        ;;
        -ccl )
            CC_SRC_LANGUAGE="$2"
            shift
        ;;
        * )
            errorln "Unknown flag: $key"
            printHelp
            exit 1
        ;;
    esac
    shift
done

if [ "${MODE}" == "up" ]; then
    networkUp
    createChannel
    elif [ "${MODE}" == "deployCC" ]; then
    deployCC
    elif [ "${MODE}" == "down" ]; then
    networkDown
    elif [ "${MODE}" == "testCC" ]; then
    if [ $CC_NAME == "contract_rawOne" ]; then
        scripts/testChaincode_rawOne.sh $CHANNEL_NAME $CC_NAME
    fi
    if [ $CC_NAME == "contract_rawTwo" ]; then
        scripts/testChaincode_rawTwo.sh $CHANNEL_NAME $CC_NAME
    fi
    if [ $CC_NAME == "contract_mlModel" ]; then
        scripts/testChaincode_mlModel.sh $CHANNEL_NAME $CC_NAME
    fi
    if [ $CC_NAME == "contract_mnist_mat" ]; then
        scripts/testChaincode_mnist_mat.sh $CHANNEL_NAME $CC_NAME
    fi
    if [ $CC_NAME == "contract_mnist_rat" ]; then
        scripts/testChaincode_mnist_rat.sh $CHANNEL_NAME $CC_NAME
    fi
else
    printHelp
    exit 1
fi