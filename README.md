# Hyperledger Fabric Test Network

In this repository you can find instructions on how to build a simple Hyperledger Fabric Network. This is a sample network with 2 Organizations. Each Organization is consist of 2 peers. The following image illustrates the network formation. 

![Test Network](https://imgur.com/XfyRKTd.png)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

NOTE : The following instractions have been tested on an Ubuntu 18.04.4 LTS Virtual Machine with 4 cores, 8GB RAM and 80GB secondary storage. 

### Prerequisites

The following have to be installed in order to make Hyperledger Fabric work : 

* [Git](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-git)
* [cURL](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-curl)
* [wget](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-wget)
* [Docker](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-docker)
* [Docker Compose](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-compose)
* [Go](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-go)
* [Node.js](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-nodejs)
* [NPM](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-npm)
* [Python 2.7](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-python-27)
* [Hyperledger Fabric Binaries and Docker Images](https://github.com/Erodotos/Hyperledger-Fabric-Network/blob/master/README.md#install-hyperledger-fabric-binaries-and-docker-images)

#### Install Git

Usually Git is already installed on Ubuntu. If not, you can use the following commands to install it. 

```
$ sudo apt install git
```

#### Install cURL

Usually cURL is already installed on Ubuntu. If not, you can use the following commands to install it.

```
$ sudo apt install curl
```
#### Install wget

Usually wget is already installed on Ubuntu. If not, you can use the following commands to install it.

```
$ sudo apt install wget
```

#### Install Docker

```
$ sudo apt install docker.io
```

Make sure the docker daemon is running.

```
$ sudo systemctl start docker
```

Optional: If you want the docker daemon to start when the system starts, use the following:

```
$ sudo systemctl enable docker
```

#### Install Docker Compose

Run this command to download the current stable release of Docker Compose.

```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Apply executable permissions to the binary.

```
sudo chmod +x /usr/local/bin/docker-compose
```

#### Install Go

Download the Go language binary archive file using following link.(In this guide we use go version 1.13.8

```
$ wget https://dl.google.com/go/go1.13.8.linux-amd64.tar.gz
$ sudo tar -xvf go1.13.8.linux-amd64.tar.gz
$ sudo mv go /usr/local
```

Now you need to setup Go language environment variables. Commonly you need to set 3 environment variables as GOROOT, GOPATH and PATH. **GOROOT** is the location where Go package is installed on your system. **GOPATH** is the location of your work directory. **PATH** variable is used to access go binary system wide.

```
$ export GOROOT=/usr/local/go
$ export GOPATH=$HOME/go
$ export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

All the above environment will be set for your current session only. **To make it permanent** add the above commands in \~/.profile (\~/.bashrc) file.

#### Install Node.js

This guide use Node.js version 8.9.4. For this reason we are going to install the specific version using NVM (Node Version Manager)

```
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
$ nvm install 8.9.4
```

#### Install NPM

Installing Node.js will also install NPM, however it is recommended that you confirm the version of NPM installed. You can upgrade the npm tool with the following command:

```
$ npm install npm@5.6.0 -g
```

#### Install Python 2.7

The following applies to Ubuntu 16.04 users only.

By default Ubuntu 16.04 comes with Python 3.5.1 installed as the python3 binary. The Fabric Node.js SDK requires an iteration of Python 2.7 in order for npm install operations to complete successfully. Retrieve the 2.7 version with the following command:

```
sudo apt-get install python
```

#### Install Hyperledger Fabric Binaries and Docker Images

Hyperledger Fabric team, provide a script that will download and install samples and binaries to your system.

```
$ curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.1 1.4.6 0.4.18
```

The command above downloads and executes a bash script that will download and extract all of the platform-specific binaries you will need to set up your network and place them into the cloned repo you created above. 

It retrieves the following platform-specific binaries:

> configtxgen

> configtxlator

> cryptogen

> discover

> idemixgen

> orderer

> peer

> fabric-ca-client

> fabric-ca-server

and places them in the bin sub-directory of the current working directory.

You may want to add that to your PATH environment variable so that these can be picked up without fully qualifying the path to each binary. e.g.:

```
$ export PATH=<path to download location>/bin:$PATH
```
The above environment will be set for your current session only. **To make it permanent** add the above commands in \~/.profile (\~/.bashrc) file.

Finally, the script will download the Hyperledger Fabric docker images from Docker Hub into your local Docker registry and tag them as ‘latest’.

## Repository Usage

