# docker-beets

[![Drone (cloud)](https://img.shields.io/drone/build/jee-r/docker-beets?&style=flat-square)](https://cloud.drone.io/jee-r/docker-beets)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/j33r/beets?style=flat-square)](https://microbadger.com/images/j33r/beets)
[![MicroBadger Layers](https://img.shields.io/microbadger/layers/j33r/beets?style=flat-square)](https://microbadger.com/images/j33r/beets)
[![Docker Pulls](https://img.shields.io/docker/pulls/j33r/beets?style=flat-square)](https://hub.docker.com/r/j33r/beets)
[![DockerHub](https://img.shields.io/badge/Dockerhub-j33r/beets-%232496ED?logo=docker&style=flat-square)](https://hub.docker.com/r/j33r/beets)

A docker image for [beets](https://beets.io) ![beet's logo](https://imgur.com/nTxLjGG.png)

This image come with [inotifywait](https://man.archlinux.org/man/inotifywait.1) for automatic rename/tag new audio file in the `WATCH_DIR`. see the `entrypoint.sh` script

# Supported tags

| Tags | Size | Layers |
|-|-|-|
| `latest`, `stable` | ![](https://img.shields.io/docker/image-size/j33r/beets/latest?style=flat-square) | ![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/j33r/beets/latest?style=flat-square) |
| `dev` | ![](https://img.shields.io/docker/image-size/j33r/beets/dev?style=flat-square) | ![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/j33r/beets/dev?style=flat-square) |

# What is Beets ?

From [beets.io](https://beets.io):

> Beets is the media library management system for obsessive music geeks.
> 
> The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes using the MusicBrainz database. Then it provides a bouquet of tools for manipulating and accessing your music.

- Source Code : https://github.com/beetbox/beets
- Documentation : https://beets.readthedocs.io
- Official Website : https://beets.io

# How to use these images

All the lines commented in the examples below should be adapted to your environment. 

Note: `--user $(id -u):$(id -g)` should work out of the box on linux systems. If your docker host run on windows or if you want specify an other user id and group id just replace with the appropriates values.

## With Docker

```bash
docker run \
    --detach \
    --interactive \
    --name beets \
    --user $(id -u):$(id -g) \
    --volume /etc/localtime:/etc/localtime:ro \
    #--volume ./config:/config \
    #--volume ./MyMusic:/Music \
    #--Volume ./Downloads:/Downloads \
    --env UMASK_SET=022 \
    #--env WATCH_DIR=/Downloads \
    --env TZ=Europe/Paris \
    #--publish 8337:8337 \
    j33r/beets:latest
```

## With Docker Compose

[`docker-compose`](https://docs.docker.com/compose/) can help with defining the `docker run` config in a repeatable way rather than ensuring you always pass the same CLI arguments.

Here's an example `docker-compose.yml` config:

```yaml
version: '3'

services:
  beets:
    image: j33r/beets:latest
    container_name: beets
    restart: unless-stopped
    user: $(id -u):$(id -g)
    #ports:
    #  - 8337:8337
    environment:
      #- WATCH_DIR=/Downloads
      - UMASK_SET=022
      - TZ=Europe/Paris
    volumes:
      #- ./config:/config
      #- ./Download:/Download
      #- ./MyMusic:/Music
      - /etc/localtime:/etc/localtime:ro
```

## Volume mounts

Due to the ephemeral nature of Docker containers these images provide a number of optional volume mounts to persist data outside of the container:

- `/config`: The Beets config directory containing `config.yaml`.
- `/Downloads`: Incomming directory, this is where new music are comming must match with `WATCH_DIR` variable.
- `/Music`: Final directory where are audio files moved after beets process is done.
- `etc/localtime`: This directory is for have the same time as host inthe container.

You should create directory before run the container otherwise directories are created by the docker deamon and owned by the root user

## Environment variables

- `WATCH_DIR`: This is where inotifywait will watch for incomming files , inotifywait is launched by default in the [`entrypoint.sh` script](/rootfs/usr/local/bin/entrypoint.sh)   
- `TZ`: To change the timezone of the container set the `TZ` environment variable. The full list of available options can be found on [Wikipedia](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
- `UMASK`: set permission of files created by the container process. More info on [ArchLinux Wiki](https://wiki.archlinux.org/title/Umask) [ArchLinux Wiki](https://wiki.archlinux.org/title/Umask).

# License

This project is under the [GNU Generic Public License v3](/LICENSE) to allow free use while ensuring it stays open.
