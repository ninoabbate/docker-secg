#!/bin/bash

# Set the tag with current date
TAG=$(date +"%Y.%m.%d-%H.%M.%S")

# Build the image
docker build --label=secg -t aabbate/secg:${TAG} -t aabbate/secg:latest .

# Push the container to Docker Hub
docker commit -p secg aabbate/secg:${TAG}
docker push aabbate/secg:${TAG}
docker commit -p secg aabbate/secg:latest
docker push aabbate/secg:latest