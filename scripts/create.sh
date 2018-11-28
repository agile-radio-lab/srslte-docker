#!/bin/bash
CONTAINER=${1:-srsall_dev}
IMAGE=${2:-srsall}
DOCKERFILE=${3:-docker/srsall/Dockerfile}
CONTEXT=${4:-.}
TAG=${5:-latest}

docker kill $CONTAINER
docker rm $CONTAINER

docker build -t $IMAGE:$TAG -f $DOCKERFILE $CONTEXT
docker run --name=$CONTAINER --network=host --privileged -di -v /lib/modules:/lib/modules -v ~/.srs:/root/.srs $IMAGE:$TAG