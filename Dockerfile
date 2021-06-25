FROM alpine:3.14

LABEL name="docker-beets" \
      maintainer="Jee jee@jeer.fr" \
      description="Beets is the media library management system for obsessive music geeks." \
      url="https://beets.io" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-beets"

COPY rootfs /
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
        py3-gobject3 \
        py3-pip \
        py3-pylast \
        python3 \
        sqlite-libs && \
    mkdir -p /tmp/mp3gain-src /tmp/mp3val-src && \
    curl -o /tmp/mp3gain-src/mp3gain.zip -sL https://sourceforge.net/projects/mp3gain/files/mp3gain/1.6.2/mp3gain-1_6_2-src.zip && \
    cd /tmp/mp3gain-src && \
    unzip -qq /tmp/mp3gain-src/mp3gain.zip && \
    make -j$(nproc) INSTALL_PATH=/usr/bin && \
    make -j$(nproc) install INSTALL_PATH=/usr/bin && \
    curl -o /tmp/mp3val-src/mp3val.tar.gz -sL https://downloads.sourceforge.net/mp3val/mp3val-0.1.8-src.tar.gz && \
    cd /tmp/mp3val-src && \
    tar xzf /tmp/mp3val-src/mp3val.tar.gz --strip 1 && \
    make -j$(nproc) -f Makefile.linux && \
    cp -p mp3val /usr/bin && \
    git clone https://github.com/acoustid/chromaprint.git /tmp/chromaprint && \
    cd /tmp/chromaprint && \
    cmake -DBUILD_TOOLS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr && \
    make -j$(nproc) && \
    make -j$(nproc) nstall && \
    pip3 install --no-cache-dir --upgrade \
        pip \
        wheel \
        notify \
        configparser \
        ndg-httpsclient \
        paramiko \
        pillow \
        psutil \
        pyopenssl \
        requests \
        setuptools \
        urllib3 \
        beautifulsoup4 \
        pillow \
        requests \
        unidecode && \
    pip3 install --no-cache-dir --upgrade \
        pylast \
        https://github.com/beetbox/beets/tarball/master \
        https://github.com/Holzhaus/beets-extrafiles/tarball/master \
        beets-bandcamp \
        discogs-client \
        beets-lidarr-fields \
        flask \
        pyacoustid && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/*

CMD ["/usr/local/bin/entrypoint.sh"]
