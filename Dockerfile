FROM alpine:3.12

LABEL name="docker-beets" \
      maintainer="Jee jee@jeer.fr" \
      description="Beets is the media library management system for obsessive music geeks." \
      url="https://beets.io" \
      org.label-schema.vcs-url="https://git.c0de.in/docker/beets"

RUN sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ircam.fr\/pub/' /etc/apk/repositories && \
    apk update && \
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
    echo "## compile mp3gain ##" && \
    mkdir -p /tmp/mp3gain-src /tmp/mp3val-src && \
    curl -o /tmp/mp3gain-src/mp3gain.zip -sL https://sourceforge.net/projects/mp3gain/files/mp3gain/1.6.2/mp3gain-1_6_2-src.zip && \
    cd /tmp/mp3gain-src && \
    unzip -qq /tmp/mp3gain-src/mp3gain.zip && \
    sed -i "s#/usr/local/bin#/usr/bin#g" /tmp/mp3gain-src/Makefile && \
    make && \
    make install && \
    echo "## compile mp3val ##" && \
    curl -o /tmp/mp3val-src/mp3val.tar.gz -sL https://downloads.sourceforge.net/mp3val/mp3val-0.1.8-src.tar.gz && \
    cd /tmp/mp3val-src && \
    tar xzf /tmp/mp3val-src/mp3val.tar.gz --strip 1 && \
    make -f Makefile.linux && \
    cp -p mp3val /usr/bin && \
    echo "## compile chromaprint ##" && \
    git clone https://github.com/acoustid/chromaprint.git /tmp/chromaprint && \
    cd /tmp/chromaprint && \
    cmake -DBUILD_TOOLS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr && \
    make && \
    make install && \
    echo "## install pip packages ##" && \
    pip3 install --no-cache-dir --upgrade \
        pip \
        wheel \
        configparser \
        ndg-httpsclient \
        notify \
        paramiko \
        pillow \
        psutil \
        pyopenssl \
        requests \
        setuptools \
        urllib3 \
        beautifulsoup4 \
        pylast \
        https://github.com/beetbox/beets/tarball/master \
        https://github.com/Holzhaus/beets-extrafiles/tarball/master \
        beets-bandcamp \
        discogs-client \
        beets-lidarr-fields \
        flask \
        pillow \
        pyacoustid \
        requests \
        unidecode && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/*

COPY ./run.sh /usr/local/bin/run.sh
CMD ["/usr/local/bin/run.sh"]
