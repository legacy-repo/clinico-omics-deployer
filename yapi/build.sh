#!/bin/bash

if [ -f "./config/yapi.env" ]; then
    source ./config/yapi.env
    echo "Build Docker Image..."
    echo "Version: ${VERSION}"
    echo "Build Version: ${YAPI_BUILD_VERSION}"
    echo "Generate .env for docker-compose"
    cp -f ./config/yapi.env .env
    cd ./docker-builder
    docker build -f Dockerfile -t ${YAPI_DOCKER_REPO}:${YAPI_BUILD_VERSION} .
else
    echo "Copy ./config/yapi.env from ./config/yapi.env.sample, and then modify the variables with your situation."
    echo "After that, retry..."
    exit 1
fi