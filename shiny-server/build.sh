#!/bin/bash

if [ -f "./config/shiny-server.env" ]; then
    source ./config/shiny-server.env
    echo "Build Docker Image..."
    echo "Build Version: ${SHINY_SERVER_BUILD_VERSION}"
    echo "Generate .env for docker-compose"
    cp -f ./config/shiny-server.env .env
    cd ./docker-builder
    docker build -f Dockerfile -t ${SHINY_SERVER_DOCKER_REPO}:${SHINY_SERVER_BUILD_VERSION} .
else
    echo "Copy ./config/shiny-server.env from ./config/shiny-server.env.sample, and then modify the variables with your situation."
    echo "After that, retry..."
    exit 1
fi