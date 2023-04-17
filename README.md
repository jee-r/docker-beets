# docker-beets

[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/j33r/beets?style=flat-square)](https://microbadger.com/images/j33r/beets)
![GitHub Workflow Status (branch)](https://img.shields.io/github/actions/workflow/status/jee-r/docker-beets/deploy.yaml?branch=main&style=flat-square)
[![Docker Pulls](https://img.shields.io/docker/pulls/j33r/beets?style=flat-square)](https://hub.docker.com/r/j33r/beets)
[![DockerHub](https://img.shields.io/badge/Dockerhub-j33r/beets-%232496ED?logo=docker&style=flat-square)](https://hub.docker.com/r/j33r/beets)
[![ghcr.io](https://img.shields.io/badge/ghrc%2Eio-jee%2D-r/beets-%232496ED?logo=github&style=flat-square)](https://ghcr.io/jee-r/beets)

A docker image for [beets](https://beets.io) ![beet's logo](https://imgur.com/nTxLjGG.png) with [automation](#automation) 


## What is Beets ?

From [beets.io](https://beets.io):

> Beets is the media library management system for obsessive music geeks.
> 
> The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes using the MusicBrainz database. Then it provides a bouquet of tools for manipulating and accessing your music.

- Source Code : https://github.com/beetbox/beets
- Documentation : https://beets.readthedocs.io
- Official Website : https://beets.io

## How to use these images

All the lines commented in the examples below should be adapted to your environment. 

Note: `--user $(id -u):$(id -g)` should work out of the box on linux systems. If your docker host run on windows or if you want specify an other user id and group id just replace with the appropriates values.


### With Docker

```bash
docker run \
    --detach \
    --interactive \
    --name beets \
    --user $(id -u):$(id -g) \
    #--publish 4030:4030 \
    #--env MODE=betanin \
    #--env BETANIN_HOST=0.0.0.0 \
    #--env BETANIN_PORT=4030 \
    #--env WATCH_DIR=/Downloads \
    --env UMASK_SET=022 \
    --env TZ=Europe/Paris \
    --volume /etc/localtime:/etc/localtime:ro \
    #--volume ./config:/config \
    #--volume ./MyMusic:/Music \
    #--Volume ./Downloads:/Downloads \
    j33r/beets:latest
```

### With Docker Compose

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
    #  - 4030:4030
    #environment:
      #- MODE=betanin
      #- BETANIN_HOST="0.0.0.0"
      #- BETANIN_PORT="4030"
      #- WATCH_DIR=/Downloads
      #- UMASK_SET=022
      #- TZ=Europe/Paris
    volumes:
      #- ./config:/config
      #- ./Download:/Download
      #- ./MyMusic:/Music
      - /etc/localtime:/etc/localtime:ro
```

### Volume mounts

Due to the ephemeral nature of Docker containers these images provide a number of optional volume mounts to persist data outside of the container:

- `/config` contain : 
  - `.config/beets`: The Beets config directory containing `config.yaml`.
  - `.config/betanin`: The Betanin config directory containing `config.toml`.
  - `.local/share/betanin/`: Containing `betanin.db` and `secret_key` files.
- `/Downloads`: Incomming directory, this is where new music are comming must match with `WATCH_DIR` variable.
- `/Music`: Final directory where are audio files moved after beets process is done.
- `etc/localtime`: This directory is for have the same time as host inthe container.

You should create directory before run the container otherwise directories are created by the docker deamon and owned by the root user

### Environment variables

- `MODE`: automation mode `inotifywait`|`betanin`|`standalone`  (default: `betanin`)
- `WATCH_DIR`: This is where `inotifywait` will watch for incomming files , only used in `inotify` `MODE`.
- `BEETS_ARGS`: add [arguments](https://beets.readthedocs.io/en/stable/reference/cli.html#import) to beet import command in entrypoint file (optional, default: `none`) 
- `TZ`: To change the timezone of the container set the `TZ` environment variable. The full list of available options can be found on [Wikipedia](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
- `UMASK`: set permission of files created by the container process. More info on [ArchLinux Wiki](https://wiki.archlinux.org/title/Umask) [ArchLinux Wiki](https://wiki.archlinux.org/title/Umask).

### Ports

- `4030`: Betanin default port can be changed in betanin config file.

### Automation

This image come with [Inotifywait](https://man.archlinux.org/man/inotifywait.1) and [Betanin](https://github.com/sentriz/betanin) this tools are used for automatic import/rename/tag new audio files.

#### Inotifywait

[Inotifywait](https://man.archlinux.org/man/inotifywait.1) efficiently waits for changes and automatic import/rename/tag new audio file in the `WATCH_DIR`.

#### Betanin

[Betanin](https://github.com/sentriz/betanin) is a [beets](https://beets.io) based man-in-the-middle of your torrent client and music player

[Betanin](https://github.com/sentriz/betanin) receive call from torrent client when the download is done then add the news files to the import queue process. 

more info : https://github.com/sentriz/betanin

## Contributing :

You are welcome to contribute to this project, but read this before please.

### Issues

Found any issue or bug in the codebase? Have a great idea you want to propose ? 
You can help by submitting an issue to the Github repository. 

**Before opening a new issue, please check if the issue has not been already made by searching 
the issues**

### Questions

We would like to have discussions and general queries related to this repository.
you can reach me on [Libera irc server](https://libera.chat/) `/query jee`

### Pull requests

Before submitting a pull request, ensure that you go through the following:

- Ensure that there is no open or closed Pull Request corresponding to your submission to avoid duplication of effort.
- Create a new branch on your forked repo based on the **main branch** and make the changes in it. Example:

```
    git clone https://your_fork
    git checkout -B patch-N main
```

- Submit the pull request, provide informations (why/where/how) in the comments section


## License

This project is under the [GNU Generic Public License v3](/LICENSE) to allow free use while ensuring it stays open.
