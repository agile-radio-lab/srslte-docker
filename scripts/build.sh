#!/bin/sh
CONTAINER=service-app
SERVICE=service
ROOT=./
IMAGE=igorskh/service-app
CONFIG_PATH_HOST=
CONFIG_PATH_CONT=
GUI=false

usage() {
    echo "Build Docker container"
    echo ""
    echo "./build.sh"
    echo "\t-h --help"
    echo "\t--container=$CONTAINER"
    echo "\t--service=$SERVICE"
    echo "\t--root=$ROOT"
    echo "\t--image=$IMAGE"
    echo "\t--config-path-host=$CONFIG_PATH_HOST"
    echo "\t--config-path-cont=$CONFIG_PATH_CONT"
    echo "\t--gui=$GUI"
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
    -s | --service)
        SERVICE=$VALUE
        ;;
    -r | --root)
        ROOT=$VALUE
        ;;
    -i | --image)
        IMAGE=$VALUE
        ;;
    --config-path-host)
        CONFIG_PATH_HOST=$VALUE
        ;;
    --config-path-cont)
        CONFIG_PATH_CONT=$VALUE
        ;;
    --gui)
        GUI=$VALUE
        ;;
    *)
        echo "ERROR: unknown parameter \"$PARAM\""
        usage
        exit 1
        ;;
    esac
    shift
done

CHECK_IMAGE="$(docker images --format "{{.Repository}}:{{.Tag}}")"
CHECK_CONTAINER="$(docker ps -a --format {{.Names}} | grep -x $CONTAINER)"

BUILD_REQUIRED=true
if [ ! "$(docker images --format "{{.Repository}}:{{.Tag}}")" ]; then
    docker build --build-arg SERVICE_FOLDER=$SERVICE --build-arg WORKFOLDER=$SRC -t $IMAGE --force-rm  $ROOT
    BUILD_REQUIRED=false
    [ ! "$(docker images -a | grep $IMAGE)" ] && echo "Unable to create image $IMAGE" && exit 1
fi

CAPABILITIES="--privileged"
RUN_ARGS="$CAPABILITIES -di -v /lib/modules:/lib/modules -d --network=host --name $CONTAINER"
[ ! -z "$CONFIG_PATH_HOST" ] && echo "Config path configured" &&  RUN_ARGS="$RUN_ARGS -v $CONFIG_PATH_HOST:$CONFIG_PATH_CONT"
[ $GUI = true ] && echo "GUI configured" && RUN_ARGS="$RUN_ARGS -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix"

[ ! "$(docker ps -a --format {{.Names}} | grep -x $CONTAINER)" ] && docker run $RUN_ARGS $IMAGE
[ ! "$(docker ps -a --format {{.Names}} | grep -x $CONTAINER)" ] && echo "Unable to create container $CONTAINER from $IMAGE" && exit 1

if $BUILD_REQUIRED; then
    echo Preserving build folder
    docker exec -w / $CONTAINER /bin/sh -c "mv /$SERVICE/build /tmp_build"
    docker exec -w / $CONTAINER /bin/sh -c "rm -rf /$SERVICE"
    echo Copying files from $ROOT to $CONTAINER:/$SERVICE
    docker cp $ROOT/. $CONTAINER:/$SERVICE
    echo Move build folder back
    docker exec -w / $CONTAINER /bin/sh -c "rm -rf /$SERVICE/build && mv /tmp_build /$SERVICE/build"
    docker exec -w /$SERVICE/build $CONTAINER /bin/sh -c "make"
fi
