FROM python:slim

LABEL name="docker-beets" \
      maintainer="Jee jee@jeer.fr" \
      description="Beets is the media library management system for obsessive music geeks." \
      url="https://beets.io" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-beets"

ARG build_deps="build-essential"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
	  build-essential \
	  curl \
	  wget \
	  git \
	  zip \
	  gzip \
	  tar \
	  cmake \
	  vim \
	  openssl \
	  inotify-tools \
	  expat \
	  mime-support \
	  libyaml-0-2 \
	  file \
	  javascript-common \
	  libjs-backbone \
	  libjs-jquery \
	  libjs-underscore \
	  libmagic-mgc \
	  libmagic1 \
	  libmpdec2 \
	  sqlite \
	  sqlite3 \
	  ffmpeg \
	  flac \
	  lame \
	  enca \
	  wavpack \
	  vorbisgain \
	  vorbis-tools \
	  opus-tools \
	  shntool \
	  cuetools \
	  libgstreamer1.0-0 \
	  libgstreamer1.0-dev \
	  gstreamer1.0-plugins-base \
	  gstreamer1.0-plugins-good \
	  gstreamer1.0-plugins-bad \
	  gstreamer1.0-plugins-ugly \
	  gstreamer1.0-libav \
	  gstreamer1.0-tools \
	  gstreamer1.0-x \
	  imagemagick \
	  libfftw3-dev \
	  libswresample-dev \
	  libavcodec-dev \
	  libavformat-dev \
	  libchromaprint-tools \
	  libpng-tools \
	  libjpeg62-turbo \
	  libmpg123-dev \
	  mpg123 \
	  fftw2 \
	  libcairo2-dev \
	  pkg-config \
	  libgirepository1.0-dev

RUN mkdir -p /tmp/mp3gain-src /tmp/mp3val-src && \
    echo "**** compile mp3gain ****" && \
    curl -o /tmp/mp3gain-src/mp3gain.zip -sL https://sourceforge.net/projects/mp3gain/files/mp3gain/1.6.2/mp3gain-1_6_2-src.zip && \
    cd /tmp/mp3gain-src && \
    unzip -qq /tmp/mp3gain-src/mp3gain.zip && \
    sed -i "s#/usr/local/bin#/usr/bin#g" /tmp/mp3gain-src/Makefile && \
    make && \
    make install

RUN echo "**** compile mp3val ****" && \
    curl -o /tmp/mp3val-src/mp3val.tar.gz -sL https://downloads.sourceforge.net/mp3val/mp3val-0.1.8-src.tar.gz && \
    cd /tmp/mp3val-src && \
    tar xzf /tmp/mp3val-src/mp3val.tar.gz --strip 1 && \
    make -f Makefile.linux && \
    cp -p mp3val /usr/bin

RUN echo "**** compile chromaprint ****" && \
    git clone https://github.com/acoustid/chromaprint.git /tmp/chromaprint && \
    cd /tmp/chromaprint && \
    cmake -DBUILD_TOOLS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr && \
    make && \
    make install

RUN echo "**** install pip packages ****" && \
    pip3 install --no-cache-dir -U \
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
      pycairo \
      PyGObject \
      https://github.com/beetbox/beets/tarball/master \
      mediafile \
      beets-extrafiles \
      beets-mpdqueue \
      beets-bandcamp \
      beets-copyartifacts \
      discogs-client \
      beets-lidarr-fields \
      flask \
      pillow \
      pip \
      pyacoustid \
      requests \
      unidecode

COPY ./run.sh /usr/local/bin/run.sh

CMD ["/usr/local/bin/run.sh"]
