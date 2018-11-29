#!/bin/bash
CONTAINER=${1:-srsall_dev}
SERVICE=${2:-srsall}
SRC=${3:-./}

echo Preserving build folder
docker exec -w / $CONTAINER /bin/sh -c "mv /$SERVICE/build /tmp_build"
docker exec -w / $CONTAINER /bin/sh -c "rm -rf /$SERVICE"
echo Copying files from $3 to $1:/$2
docker cp $SRC/. $CONTAINER:/$SERVICE
echo Move build folder back
docker exec -w / $CONTAINER /bin/sh -c "rm -rf /$SERVICE/build && mv /tmp_build /$SERVICE/build"
docker exec -w /$SERVICE/build $CONTAINER /bin/sh -c "make"