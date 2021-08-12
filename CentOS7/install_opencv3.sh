# Install OPENCV3
set -e

yum install -y epel-release git gcc gcc-c++ qt5-qtbase-devel cmake gtk2-devel libpng-devel jasper-devel openexr-devel libwebp-devel     libjpeg-turbo-devel libtiff-devel libdc1394-devel tbb-devel numpy     eigen3-devel gstreamer-plugins-base-devel freeglut-devel mesa-libGL  mesa-libGL-devel boost boost-thread boost-devel libv4l-devel
yum install -y cmake3 make

BUILD_DIR=~/opencv_src
INSTALL_DIR=/usr/local
VERSION=3.4.9
mkdir -p $BUILD_DIR && cd $BUILD_DIR
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git


# https://github.com/opencv/opencv_contrib/issues/1824
cd opencv
git checkout $VERSION
cd ../opencv_contrib
git checkout $VERSION

cd $BUILD_DIR/opencv && mkdir build && cd build

cmake3 -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=$BUILD_DIR/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..

make -j8
make install
ln -s $INSTALL_DIR/lib64/pkgconfig/opencv.pc /usr/share/pkgconfig/
ldconfig
