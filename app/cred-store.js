/**
 * Demonstrates the setup of the credential store
 */
const fs = require('fs');
const Client = require('fabric-client');
const path = require('path');

// Constants for profile, wallet & user
const CONNECTION_PROFILE_PATH = './profiles/dev-connect.yaml'

// Client section configuration
const CLIENT_CONNECTION_PROFILE_PATH = './profiles/org1-client.yaml'


const CRYPTO_CONFIG = path.resolve(__dirname, '../network/organizations');
const CRYPTO_CONFIG_PEER_ORGANIZATIONS = path.join(CRYPTO_CONFIG, 'peerOrganizations')

const client = Client.loadFromConfig(CONNECTION_PROFILE_PATH)

main()

// Main function
async function main() {
    // Input data sanity check
    if (process.argv.length < 4) {
        console.log("Usage:  node   cred-store.js   org    user-name")
        process.exit(1)
    }

    // Set the org and name local variables
    let org = process.argv[2]
    let user = process.argv[3]

    // Load the client section for the organization
    // This has the location of the credential store

    client.loadFromConfig(CLIENT_CONNECTION_PROFILE_PATH)


    // Initialize the store
    await initCredentialStore()

    // Lets get the specified user from the store
    let userContext = await client.loadUserFromStateStore(user)

    // If user is null then the user does not exist
    if (userContext == null) {

        // Create the user context
        userContext = await createUserContext(org, user)

        console.log(`Created ${user} under the credentials store!!`)
    } else {
        console.log(`User ${user} already exist!!`)
    }

    // Setup the context on the client
    await client.setUserContext(userContext, false)

    // At this point client can be used for sending requests to Peer | Orderer
}

async function initCredentialStore() {

    // Call the function for initializing the credentials store on file system
    await client.initCredentialStores()
        .then((done) => {
            console.log("initCredentialStore(): ", done)
        })
}

async function createUserContext(org, user) {
    // Get the path  to user private key
    let privateKeyPath = getPrivateKeyPath(org, user)

    // Get the path to the user certificate
    let certPath = getCertPath(org, user)

    // Setup the options for the user context
    // Global Type: UserOpts 
    let opts = {
        username: user,
        mspid: createMSPId(org),
        cryptoContent: {
            privateKey: privateKeyPath,
            signedCert: certPath
        },
        skipPersistence: false
    }

    // Setup the user 
    let userContext = await client.createUser(opts)

    return userContext
}

function getCertPath(org, user) {
    var certPath = CRYPTO_CONFIG_PEER_ORGANIZATIONS + "/" + org + ".example.com/users/" + user + "@" + org + ".example.com/msp/signcerts/" + user + "@" + org + ".example.com-cert.pem"
    return certPath
}

function getPrivateKeyPath(org, user) {
    var pkFolder = CRYPTO_CONFIG_PEER_ORGANIZATIONS + "/" + org + ".example.com/users/" + user + "@" + org + ".example.com/msp/keystore"
    fs.readdirSync(pkFolder).forEach(file => {
        pkfile = file
        return
    })

    return (pkFolder + "/" + pkfile)
}

function createMSPId(org) {
    return org.charAt(0).toUpperCase() + org.slice(1) + 'MSP'
}