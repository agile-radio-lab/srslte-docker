# Docker support for srsLTE

This repository contains Dockerfiles to build images and deploy containers for [srsLTE](https://github.com/srsLTE/srsLTE) with [Universal Software Radio Peripheral (USRP™) SDR](https://github.com/EttusResearch/uhd) frontend support.

By using Docker image there is no need to install build dependencies on the host.

The srsLTE can be easily deployed for different front-end devices and driver versions. srsLTE images can be tagged differently for testing and deployment.

Folders `uhd` and `srslte` contain base images for Ettus UHD and srsLTE dependencies correspondingly.

Folder `scripts` contains useful scripts to build containers and perfrom build and run operations.

## TODO
* Add namings and tags description to the README
* Add srsGUI support
* Extract binaries from docker container to the README
* Create a production build

## Configuration files
Configuration files folder can be mount from a default `~/.srs/ ` location on the host machine.

## Build the base UHD image
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

## Build the base srsLTE image
The base srsLTE image contains common dependencies and based on Ubuntu Linux distribution.

To build a base image run:
```
cd srslte
docker build -t srslte:latest .
```

To build a base image with UHD support
```
cd srslte_uhd
docker build -t srslte:uhd .
```

All other images such as combined srsEPC, srsENB and srsUE will use this base image.

## Build srsLTE
From the root folder of the srsLTE repository run:
```
docker build -t srsall:latest -f docker/srsall/Dockerfile .
```
The command above specifies a context in a current directory, which allows copying the srsLTE repository to a docker container, otherwise file operations are limited to a context. An image will be tagged as `srsall:latest`.

In order to create and run a container:
```
docker run --name=srsall_dev --network=host --privileged -di -v /lib/modules:/lib/modules -v ~/.srs:/root/.srs srsall:latest
```

Flag `d` runs a container in detached mode.

Flag `i` keeps container running.

`srsall_dev` is a container name and can be changed to any other name.

Or use a script to perform the steps above:
```
./docker/scripts/create.sh srsall_dev
```

## Rebuild srsLTE
To rebuild/recompile the code run:
```
cd docker/srsall/
./docker/scripts/rebuild.sh srsall_dev srsall ./
```

Where `srsall_dev` is a container name created before and `srsall` is a service name.

In the same way several instances of the image `srsall:latest` can be created, for example for srsENB, srsEPC or srsUE.

## Run srsLTE from combined image
To run a certain service from the srsall folder, a script `run.sh` can be used:
```
./docker/scripts/run.sh srsall_dev srsenb enb.conf srsall
```
* First positional argument is a container name
* Second positional argument is an application name
* Third arg is a configuration file name in a mounted folder
* Forth arg is a service name

## Automatization for Visual Studio Code
File `example.tasks.json` contains tasks for the VS Code to build and run srsLTE.

The file should be placed in the .vscode folder of the project such as:
```
cp example.tasks.json ../.vscode/tasks.json
```

Then tasks can be called as `Ctrl+Shift+P` -> `Tasks: Run task` -> Choose task here.