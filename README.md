# docker-beets
[![Drone (cloud)](https://img.shields.io/drone/build/jee-r/docker-beets?style=flat-square)](https://cloud.drone.io/jee-r/docker-beets)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/j33r/beets?style=flat-square)](https://microbadger.com/images/j33r/beets)
[![MicroBadger Layers](https://img.shields.io/microbadger/layers/j33r/beets?style=flat-square)](https://microbadger.com/images/j33r/beets)
[![Docker Pulls](https://img.shields.io/docker/pulls/j33r/beets?style=flat-square)](https://hub.docker.com/r/j33r/beets)
[![DockerHub](https://img.shields.io/badge/Dockerhub-j33r/beets-%232496ED?logo=docker&style=flat-square)](https://hub.docker.com/r/j33r/beets)

A docker image for [beets](https://beets.io) ![beet's logo](https://imgur.com/nTxLjGG.png)
## Usage

This image come with inotify-wait for automatic rename/tag new audio file in the `WATCH_DIR`. see the `run.sh` file

## docker-compose

```
version: '3.8'

services:
  beets:
    image: j33r/beets:latest
    container_name: beets
    restart: unless-stopped
    user: 1000:1000
    #ports:
    #  - 8337:8337
    environment:
      - HOME=/config
      - WATCH_DIR=/Media/Music/Unsorted
      - UMASK_SET=022
      - TZ=Europe/Paris
    volumes:
      - ./config:/config
      - ${HOME}/Download:/Download
      - /etc/localtime:/etc/localtime:ro
```
