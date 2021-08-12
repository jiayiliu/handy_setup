# Install FFMPEG on CentOS 7
# Ref: https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
# `bash install_ffmpeg.sh`
# Require sudo
set -e

# Common variables
## Installation path
INSTALL_DIR=$HOME/ffmpeg_build
SRC_DIR=$HOME/ffmpeg_src
VERSION=4.4
PATH="$INSTALL_DIR/bin:$INSTALL_DIR/share$PATH"

echo "Install to $INSTALL_DIR"
echo "FFMEPG VERSION: ${VERSION}"

yum install -y autoconf automake bzip2 bzip2-devel cmake freetype-devel gcc gcc-c++ git libtool make pkgconfig zlib-devel
mkdir -p $INSTALL_DIR $SRC_DIR

# NASM
cd $SRC_DIR
curl -O -L https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2
tar xjvf nasm-2.15.05.tar.bz2
cd nasm-2.15.05
./autogen.sh
./configure --prefix="$INSTALL_DIR" --bindir="$INSTALL_DIR/bin"
make
make install

# Yasm
cd $SRC_DIR
curl -O -L -k https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$INSTALL_DIR" --bindir="$INSTALL_DIR/bin"
make
make install

# x264
cd $SRC_DIR
git clone --branch stable --depth 1 https://code.videolan.org/videolan/x264.git
cd x264
PKG_CONFIG_PATH="$INSTALL_DIR/lib/pkgconfig" ./configure --prefix="$INSTALL_DIR" --bindir="$INSTALL_DIR/bin" --enable-static
make
make install

# x265
cd $SRC_DIR
git clone --branch stable --depth 2 https://bitbucket.org/multicoreware/x265_git
cd $SRC_DIR/x265_git/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DENABLE_SHARED:bool=off ../../source
make
make install

# fdk_acc
cd $SRC_DIR
git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$INSTALL_DIR" --disable-shared
make
make install

# mp3lame
cd $SRC_DIR
curl -O -L https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="$INSTALL_DIR" --bindir="$INSTALL_DIR/bin" --disable-shared --enable-nasm
make
make install

# opus
cd $SRC_DIR
curl -O -L https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
tar xzvf opus-1.3.1.tar.gz
cd opus-1.3.1
./configure --prefix="$INSTALL_DIR" --disable-shared
make
make install

# vpx
cd $SRC_DIR
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$INSTALL_DIR" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
make
make install

# ffmpeg
cd $SRC_DIR
curl -O -L https://ffmpeg.org/releases/ffmpeg-${VERSION}.tar.bz2
tar xjvf ffmpeg-${VERSION}.tar.bz2
cd ffmpeg-${VERSION}
PKG_CONFIG_PATH="$INSTALL_DIR/lib/pkgconfig" ./configure \
  --prefix="$INSTALL_DIR" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$INSTALL_DIR/include" \
  --extra-ldflags="-L$INSTALL_DIR/lib" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
make
make install  # not working well
cp ffmpeg ffprobe ${INSTALL_DIR}/bin/
# hash -d ffmpeg
