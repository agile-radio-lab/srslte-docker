#!/bin/bash
CONTAINER=${1:-srsall_dev}
SERVICE=${2:-srsall}
SRC=${3:-./}

docker cp $SRC $CONTAINER:/$SERVICE
docker exec $CONTAINER /bin/sh -c "cd /$SERVICE/build && make"