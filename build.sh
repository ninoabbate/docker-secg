#!/bin/bash

# Get the latest release tag
TAG=$(curl https://api.github.com/repos/prometheus/snmp_exporter/releases/latest -s | jq .tag_name -r)

# Set the version in Dockerfile before building the container
OS=$(uname -a | awk '{print $1}')
if [ $OS = "Darwin" ]; then
    # If the operating system where this script runs is OSX
    sed -i'' -e 's/ENV APP_VERSION/ENV APP_VERSION '${TAG}'/' ${PWD}/Dockerfile
    rm -rf ${PWD}/Dockerfile-e
else
    sed -i 's/ENV APP_VERSION/ENV APP_VERSION '${TAG}'/' ${PWD}/Dockerfile
fi

# Build the image
docker build --label=secg -t aabbate/secg:${TAG} -t aabbate/secg:latest .

# Push the container to DockerHub
docker commit -p secg aabbate/secg:${TAG}
docker push aabbate/secg:${TAG}
docker commit -p secg aabbate/secg:latest
docker push aabbate/secg:latest

# Remove the tag from Dockerfile
if [ $OS = "Darwin" ]; then
    # If the operating system where this script runs is OSX
    sed -i'' -e 's/ENV APP_VERSION '${TAG}'/ENV APP_VERSION/' ${PWD}/Dockerfile
    rm -rf ${PWD}/Dockerfile-e
else
    sed -i 's/ENV APP_VERSION '${TAG}'/ENV APP_VERSION/' ${PWD}/Dockerfile
fi