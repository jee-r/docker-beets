FROM alpine:3.14.2 AS builder-mp3gain
WORKDIR /tmp
COPY build/mp3gain/APKBUILD .
RUN apk update && \
    apk add --no-cache abuild && \
    abuild-keygen -a -n && \
    REPODEST=/tmp/out abuild -F -r

FROM alpine:3.14.2 AS builder-mp3val
WORKDIR /tmp
COPY build/mp3val/APKBUILD .
RUN apk update && \
    apk add --no-cache abuild && \
    abuild-keygen -a -n && \
    REPODEST=/tmp/out abuild -F -r

FROM python:3.10-alpine3.14

LABEL name="docker-beets" \
      maintainer="Jee jee@jeer.fr" \
      description="Beets is the media library management system for obsessive music geeks." \
      url="https://beets.io" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-beets" \
      org.opencontainers.image.source="https://github.com/jee-r/docker-beets"

COPY rootfs /
COPY --from=builder-mp3gain /tmp/out/*/*.apk /pkgs/
COPY --from=builder-mp3val /tmp/out/*/*.apk /pkgs/

ENV HOME=/config

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --virtual=base --upgrade \
        bash \
        vim \
        curl \
        wget \
        ca-certificates \
        coreutils \
        procps \
        tar \
        xz \
        gzip \
        tzdata && \
    apk add --no-cache --virtual=build-dependencies --upgrade \
        build-base \
        git \
        zip \
        make \
        cmake \
        g++ \
        gcc \
        musl-dev \
        cargo \
        libffi-dev \
        python3-dev \
        openssl-dev \
        jpeg-dev \
        libpng-dev \
        mpg123-dev \
        ffmpeg-dev \
        fftw-dev && \
    apk add --upgrade --no-cache \
        inotify-tools \
        chromaprint \
        expat \
        ffmpeg \
        ffmpeg-libs \
        fftw \
        flac \
        gdbm \
        gst-plugins-good \
        gstreamer \
        jpeg \
        lame \
        libffi \
        libpng \
        mpg123 \
        openjpeg \
        sqlite-libs && \
    apk add --no-cache --allow-untrusted /pkgs/* && \
    python3 -m ensurepip && \
    pip3 install --no-cache-dir --upgrade \
        pip \
        https://github.com/beetbox/beets/tarball/master \
        https://github.com/Holzhaus/beets-extrafiles/tarball/master \
        beets-bandcamp \
        discogs-client \
        beets-lidarr-fields \
        pyacoustid \
        wheel \
        pylast && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/*

CMD ["/usr/local/bin/entrypoint.sh"]
