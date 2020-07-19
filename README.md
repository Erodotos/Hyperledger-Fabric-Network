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

#### Install Python 2.7

#### Install Hyperledger Fabric Binaries and Docker Images
```
Give examples
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds
