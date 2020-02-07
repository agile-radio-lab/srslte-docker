# Docker support for srsLTE

This repository contains Dockerfiles to build images and deploy containers for [srsLTE](https://github.com/srsLTE/srsLTE) with [Universal Software Radio Peripheral (USRP™) SDR](https://github.com/EttusResearch/uhd) frontend support.

By using Docker image there is no need to install build dependencies on the host.

The srsLTE can be easily deployed for different front-end devices and driver versions. srsLTE images can be tagged differently for testing and deployment.

Folders `uhd` and `srslte` contain base images for Ettus UHD and srsLTE dependencies correspondingly.

Folder `scripts` contains useful scripts to build containers and perform build and run operations.

## Requirements
* Docker 18

## TODO
* Add namings and tags description to the README
* Add srsGUI support
* Extract binaries from docker container to the README
* Create a production build

## Dockerfile Example
The following Dockerfile is building srsLTE:
```bash
FROM igorskh/srslte

ARG WORKFOLDER=./
ARG SERVICE_FOLDER=srslte

COPY $WORKFOLDER /$SERVICE_FOLDER
RUN rm -rf /$SERVICE_FOLDER/build
RUN mkdir /$SERVICE_FOLDER/build
WORKDIR /$SERVICE_FOLDER/build
RUN cmake ../ &&\
    make
```

Image  igorskh/srslte contains necessary dependencies, corresponding [Dockerfile](srslte_uhd/Dockerfile) is located in [srslte_uhd](srslte_uhd).
For other UHD versions new image has to be generated.

## Build srsLTE
Build script is located in [scripts/build.sh](scripts/build.sh), with prepared Dockerfile it can be used as following
```bash
~/srslte-docker/scripts/build.sh \
    --container=srslte-app \
    --service=srslte \
    --root=$(pwd) \
    --image=igorskh/srslte-app \
    --config-path-host=~/dev/srsLTE/srslte-config \
    --config-path-cont=/root/.config/srslte \
    --gui=true
```

`~/srslte-docker` is location of this repository.

The arguments are the following:
* `--container` - a container name
* `--service` - a subfolder name which will be created in the root of the  
* `--root` - the location of the srsLTE repository
* `--image` - the Docker image name which will be given to the built image
* `--config-path-host` - location of the configuration files folder on the host
* `--config-path-cont` - location of the configuration files folder in the container
* `--gui` - enable X11 passthrough to the container if true

The same script can be used for rebuilding the source code, the `build` folder will be preserved.

## Run srsLTE in Docker
Run script is located in [scripts/build.sh](scripts/run.sh)

Example:
```bash
~/srslte-docker/run.sh \
    --container=srslte-app \
    --app=srsenb \
    --root=build/srsenb/src \
    --service=srslte
```

The arguments are the following:
* `--container` - a container name, should be same as for the build step
* `--app` - executable name
* `--root` - path relative to the `/$service`
* `--service` - service name, should be the same as for the build step

In this example the script will run `/srslte/build/srsenb/src/srsenb` executable.

## Automatization for Visual Studio Code
File `example.tasks.json` contains tasks for the VS Code to build and run srsLTE.

The file should be placed in the .vscode folder of the project such as:
```
cp example.tasks.json ../.vscode/tasks.json
```

Then tasks can be called as `Ctrl+Shift+P` -> `Tasks: Run task` -> Choose task here.

## OPTIONAL: Build the base UHD image
By default the base image containing the UHD installation is:
```
cd uhd
docker build -t uhd:latest .
```

This will create an `uhd:latest docker` image.

Optionally the version of the UHD can be passed as

```
docker build --build-arg uhd_tag=release_003_010_003_000 .
```

Images srsENB and srsUE will use this base image.