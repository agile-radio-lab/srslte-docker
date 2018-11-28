#!/bin/bash
CONTAINER=${1:-srsall_dev}
APP=${2:-srsenb}
CONF=${3:-srsenb.conf}
SERVICE=${4:-srsall}

docker exec -it $CONTAINER /bin/sh -c "cd /$SERVICE/build/$APP/src && ./$APP /root/.srs/$CONF"