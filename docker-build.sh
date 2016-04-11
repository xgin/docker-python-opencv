#!/bin/bash -e

NUM_CORES=$(nproc)

cd /usr/local/src

apt-get update -qq
apt-get install -y --force-yes \
    ant \
    autoconf \
    automake \
    build-essential \
    curl \
    checkinstall \
    cmake \
    default-jdk \
    f2c \
    gfortran \
    git \
    g++ \
    imagemagick \
    libass-dev \
    libatlas-base-dev \
    libavcodec-dev \
    libavformat-dev \
    libcnf-dev \
    libfreeimage-dev \
    libjpeg-dev \
    libjasper-dev \
    libgnutls28-dev \
    liblapack3 \
    libmp3lame-dev \
    libpq-dev \
    libpng-dev \
    libssl-dev \
    libtheora-dev \
    libtiff5-dev \
    libtool \
    libxine2-dev \
    libxvidcore-dev \
    libv4l-dev \
    libvorbis-dev \
    mercurial \
    openssl \
    pkg-config \
    postgresql-client \
    supervisor \
    wget \
    unzip

pip install numpy
 
git clone --depth 1 https://github.com/l-smash/l-smash
git clone --depth 1 git://git.videolan.org/x264.git
hg clone https://bitbucket.org/multicoreware/x265
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
git clone https://github.com/Itseez/opencv.git
git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx
git clone --depth 1 git://git.opus-codec.org/opus.git
git clone --depth 1 https://github.com/mulx/aacgain.git

curl -Os http://www.tortall.net/projects/yasm/releases/yasm-${YASM_VERSION}.tar.gz
tar xzvf yasm-${YASM_VERSION}.tar.gz

# Build YASM
# =================================
cd /usr/local/src/yasm-${YASM_VERSION}
./configure
make -j ${NUM_CORES}
make install
# =================================

# Build L-SMASH
# =================================
cd /usr/local/src/l-smash
./configure
make -j ${NUM_CORES}
make install
# =================================


# Build libx264
# =================================
cd /usr/local/src/x264
./configure --enable-static
make -j ${NUM_CORES}
make install
# =================================


# Build libx265
# =================================
cd  /usr/local/src/x265/build/linux
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ../../source
make -j ${NUM_CORES}
make install
# =================================

# Build libfdk-aac
# =================================
cd /usr/local/src/fdk-aac
autoreconf -fiv
./configure --disable-shared
make -j ${NUM_CORES}
make install
# =================================

# Build libvpx
# =================================
cd /usr/local/src/libvpx
./configure --disable-examples
make -j ${NUM_CORES}
make install
# =================================

# Build libopus
# =================================
cd /usr/local/src/opus
./autogen.sh
./configure --disable-shared
make -j ${NUM_CORES}
make install
# =================================



# Build OpenCV 3.x
# =================================
apt-get install -y --force-yes libopencv-dev
cd /usr/local/src
mkdir -p opencv/release
cd /usr/local/src/opencv/release
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D WITH_TBB=ON \
      -D BUILD_PYTHON_SUPPORT=ON \
      -D WITH_V4L=ON \
       ..
make -j ${NUM_CORES}
make install
sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
ldconfig
# =================================


# Build ffmpeg.
# =================================
apt-get install -y --force-yes libass-dev
#            --enable-libx265 - Remove until we can debug compile error
cd /usr/local/src/ffmpeg
./configure --extra-libs="-ldl" \
            --enable-gpl \
            --enable-libass \
            --enable-libfdk-aac \
            --enable-libfontconfig \
            --enable-libfreetype \
            --enable-libfribidi \
            --enable-libmp3lame \
            --enable-libopus \
            --enable-libtheora \
            --enable-libvorbis \
            --enable-libvpx \
            --enable-libx264 \
            --enable-nonfree
make -j ${NUM_CORES}
make install
# =================================


# Remove all tmpfile
# =================================
cd /usr/local/
rm -rf /usr/local/src
apt-get clean
# =================================

