FROM node:16.11.1-bullseye-slim AS builder-frontend
WORKDIR /src
RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends \
        git \
        ca-certificates \
        build-essential && \
    git clone https://github.com/sentriz/betanin.git . && \ 
    cd /src/betanin_client && \
    npm install && \
    PRODUCTION=true npm run-script build

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

FROM alpine:3.14.2

LABEL name="docker-beets" \
      maintainer="Jee jee@jeer.fr" \
      description="Beets is the media library management system for obsessive music geeks." \
      url="https://beets.io" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-beets" \
      org.opencontainers.image.source="https://github.com/jee-r/docker-beets"

COPY rootfs /
COPY --from=builder-frontend /src/betanin_client/dist/ /src/betanin_client/dist/
COPY --from=builder-mp3gain /tmp/out/*/*.apk /pkgs/
COPY --from=builder-mp3val /tmp/out/*/*.apk /pkgs/

WORKDIR /src

ENV HOME=/config \
    MODE=betanin \
    BETANIN_HOST=0.0.0.0 \
    BETANIN_PORT=4030 \
    UMASK_SET=022 \
    TZ=Europe/Paris

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
        zlib-dev \ 
        python3-dev \
        openssl-dev \
        jpeg-dev \
        libpng-dev \
        mpg123-dev \
        ffmpeg-dev \
        fftw-dev && \
    apk add --upgrade --no-cache \
        python3 \
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
        py3-gobject3 \
        jpeg \
        lame \
        libffi \
        libpng \
        libev \
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
        requests \
        beautifulsoup4 \
        pillow \
        unidecode \
        pylast && \
    git clone https://github.com/sentriz/betanin.git/ && \
    cd /src/betanin && \
    pip3 install --no-cache-dir . --requirement requirements-docker.txt && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/* /pkgs ~/.cache 

CMD ["/usr/local/bin/entrypoint.sh"]
