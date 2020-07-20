#!/bin/bash

IMAGETAG="latest"

COMPOSE_FILE_BASE=./configurations/docker-base.yaml
COMPOSE_FILE_MAIN=./configurations/docker.yaml

COMPOSE_FILES="-f ${COMPOSE_FILE_BASE} -f ${COMPOSE_FILE_MAIN}"

# Shut down docker containers
docker-compose $COMPOSE_FILES down --volumes --remove-orphans