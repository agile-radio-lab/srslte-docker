#!/bin/sh
CONTAINER=service-app
APP=app
SERVICE=service
PARAMS=
CONFIG_PATH=
CONFIG_NAME=
DETACHED=false

usage() {
    echo "Run Docker container"
    echo ""
    echo "./build.sh"
    echo "\t-h --help"
    echo "\t--container=$CONTAINER"
    echo "\t--root=$ROOT"
    echo "\t--app=$APP"
    echo "\t--service=$SERVICE"
    echo "\t--params=$PARAMS"
    echo "\t--config-path=$CONFIG_PATH"
    echo "\t--config-name=$CONFIG_NAME"
    echo "\t--detached=$DETACHED"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=$(echo $1 | awk -F= '{print $1}')
    VALUE=$(echo $1 | awk -F= '{print $2}')
    case $PARAM in
    -h | --help)
        usage
        exit 0
        ;;
    -c | --container)
        CONTAINER=$VALUE
        ;;
    -r | --root)
        ROOT=$VALUE
        ;;
    -a | --app)
        APP=$VALUE
        ;;
    -s | --service)
        SERVICE=$VALUE
        ;;
    -p | --params)
        PARAMS=$VALUE
        ;;
    --config-path)
        CONFIG_PATH=$VALUE
        ;;
    --config-name)
        CONFIG_NAME=$VALUE
        ;;
    --detached)
        DETACHED=$VALUE
        ;;
    *)
        echo "ERROR: unknown parameter \"$PARAM\""
        usage
        exit 1
        ;;
    esac
    shift
done

[ "$(docker ps | grep $CONTAINER)" ] && docker kill $CONTAINER
docker start $CONTAINER

RUN_ARGS=./$APP $PARAMS
[ ! -z "$CONFIG_PATH" ] && RUN_ARGS="$RUN_ARGS $CONFIG_PATH/"
[ ! -z "$CONFIG_NAME" ] && RUN_ARGS="$RUN_ARGS$CONFIG_NAME"

START_PARAMS="-it"
[ $DETACHED = true ] && START_PARAMS="-d"

docker exec -w /$SERVICE/$ROOT $START_PARAMS $CONTAINER /bin/sh -c "$RUN_ARGS"