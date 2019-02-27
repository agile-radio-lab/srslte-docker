#!/bin/bash
CONTAINER=${1:-srsall_dev}
APP=${2:-srsenb}
CONF=${3:-srsenb.conf}
SERVICE=${4:-srsall}
PARAMS=${5:-}
CONFIGPATH=${6:-/root/.config/srslte}

docker exec -w /$SERVICE/build/$APP/src -it $CONTAINER /bin/sh -c "./$APP $PARAMS $CONFIGPATH/$CONF"