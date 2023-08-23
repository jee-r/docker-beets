FROM node:20-alpine3.17 AS builder-frontend
WORKDIR /src
RUN apk add git && \
    git clone https://github.com/sentriz/betanin.git . && \
    cd /src/betanin_client && \
    npm install && \
    PRODUCTION=true npm run-script build

FROM alpine:3.18 AS builder-mp3gain
WORKDIR /tmp
COPY build/mp3gain/APKBUILD .
RUN apk update && \
    apk add --no-cache abuild && \
    abuild-keygen -a -n && \
    REPODEST=/tmp/out abuild -F -r

FROM alpine:3.18 AS builder-mp3val
WORKDIR /tmp
COPY build/mp3val/APKBUILD .
RUN apk update && \
    apk add --no-cache abuild && \
    abuild-keygen -a -n && \
    REPODEST=/tmp/out abuild -F -r

FROM alpine:3.18

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
    BEETSDIR=/config/.config/beets \
    FPCALC=/usr/bin/fpcalc \
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
        lame \
        libffi \
        libev \
        mpg123 \
	    imagemagick \
        jpeg \
        libpng \
        openjpeg \
        sqlite-libs \
        keyfinder-cli && \
    apk add --no-cache --allow-untrusted /pkgs/* && \
    python3 -m ensurepip && \
    pip3 install --no-cache-dir --upgrade \
        pip \
        https://github.com/beetbox/beets/tarball/master \
        #https://github.com/Holzhaus/beets-extrafiles/tarball/master \
        https://github.com/jee-r/beets-extrafiles/tarball/main \
        beetcamp \
        discogs-client \
        beets-lidarr-fields \
        beets-noimport \
        pyacoustid \
        wheel \
        requests \
        beautifulsoup4 \
        pillow \
        unidecode \
        pylast && \
    # Install Betanin
    git clone https://github.com/sentriz/betanin.git/ && \
    #git clone --single-branch --branch dev https://github.com/jee-r/betanin.git/ && \
    cd /src/betanin && \
    # we don't need to install requirement below all deps is already installed 
    # see https://github.com/sentriz/betanin/blob/master/requirements-docker.txt
    #pip3 install --no-cache-dir . --requirement requirements-docker.txt && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/* /pkgs ~/.cache 

CMD ["/usr/local/bin/entrypoint.sh"]
