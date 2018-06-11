#!/bin/sh -x
# 
# https://www.pyimagesearch.com/2016/04/18/install-guide-raspberry-pi-3-raspbian-jessie-opencv-3/


x=`dpkg -l wolfram-engine| grep ^ii`
if [ "x$x" != "x" ] ; then
   sudo apt-get purge wolfram-engine;
fi

sudo apt-get install \
     build-essential \
     cmake \
     pkg-config \
     libpng-dev \
     libjpeg-dev \
     libtiff5-dev \
     libjasper-dev \
     libavcodec-dev \
     libavformat-dev \
     libswscale-dev \
     libv4l-dev \
     libxvidcore-dev \
     libx264-dev \
     libgtk-3-dev \
     libgdk-pixbuf2.0-dev \
     libpango1.0-dev \
     libcairo2-dev \
     libfontconfig1-dev \
     libatlas-base-dev \
     gfortran \
     python-pip \
     python2.7-dev \
     python3-dev \
     python3-pip \
     python-numpy \
     python3-numpy \
     ccache \
     libeigen2-dev \
     libeigen3-dev \
     libopenexr-dev \
     libgstreamer1.0-dev \
     libgstreamermm-1.0-dev \
     liblapack-dev \
     libprotobuf-dev

# https://www.pyimagesearch.com/2016/04/18/install-guide-raspberry-pi-3-raspbian-jessie-opencv-3/
# https://qiita.com/PonDad/items/c5419c164b4f2efee368
# TODO:
# libavresample -dev
# libgphoto2 -dev
# OpenBLAS -dev
# vtk -dev
# protobuf not found
# protobuf
# glog
# gflags
# tiny-dnn
# HDF5
# gtkglext
# lapack
# libwebp

wget -c -O opencv.zip https://github.com/opencv/opencv/archive/3.4.1.zip
wget -c -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.1.zip

unzip opencv.zip
unzip opencv_contrib.zip
cd opencv-3.4.1
mkdir -p build
cd build

export CXXFLAGS='-mtune=cortex-a53 -march=armv8-a+crc -mcpu=cortex-a53 -mfpu=crypto-neon-fp-armv8'

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-3.4.1/modules \
      -D BUILD_ZLIB=OFF \
      -D BUILD_TIFF=OFF \
      -D BUILD_JASPER=OFF \
      -D BUILD_PNG=OFF \
      -D BUILD_OPENEXR=OFF \
      -D BUILD_SHARED_LIBS=ON \
      -D BUILD_CUDA_STUBS=ON \
      -D WITH_EIGEN=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_GTK=ON \
      -D WITH_JASPER=ON \
      -D WITH_JPEG=ON \
      -D WITH_OPENEXR=ON \
      -D WITH_PNG=ON \
      -D WITH_TIFF=ON \
      -D WITH_V4L=ON \
      -D WITH_LAPACK=ON \
      -D WITH_PROTOBUF=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D ENABLE_CCACHE=ON \
      -D ENABLE_NEON=ON \
      -D ENABLE_VFPV3=ON \
      .. && make && sudo checkinstall && sudo ldconfig

sudo dpkg -i opencv_20??????-1_armhf.deb
