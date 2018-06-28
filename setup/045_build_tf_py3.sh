#!/bin/bash -x
# refer to https://karaage.hatenadiary.jp/entry/2017/08/09/073000
# refer to http://uepon.hatenadiary.com/entry/2018/02/12/113432

V=1.8.0

wget -c https://github.com/tensorflow/tensorflow/archive/v${V}.tar.gz
#TODO tar xzf v${V}.tar.gz

sudo apt-get install \
     libeigen2-dev libeigen3-dev \
     libblas-dev liblapack-dev \
     libatlas-base-dev gfortran

cd tensorflow-$V && grep -Rl 'lib64' | xargs sed -i 's/lib64/lib/g'

# TODO: as-a-work-around.
sed -i 's/ ConcatCPU/ \/\/ConcatCPU/;' tensorflow/core/kernels/list_kernels.h

(PYTHON_BIN_PATH=/usr/bin/python3 \
 PYTHON_LIB_PATH=/usr/local/lib/python3.5/dist-packages \
 TF_NEED_JEMALLOC=1 \
 TF_NEED_GCP=0 \
 TF_NEED_CUDA=0 \
 TF_NEED_S3=0 \
 TF_NEED_HDFS=0 \
 TF_NEED_KAFKA=0 \
 TF_NEED_OPENCL_SYCL=0 \
 TF_NEED_OPENCL=0 \
 TF_CUDA_CLANG=0 \
 TF_DOWNLOAD_CLANG=0 \
 TF_ENABLE_XLA=0 \
 TF_NEED_GDR=0 \
 TF_NEED_VERBS=0 \
 TF_NEED_MPI=0 \
 TF_SET_ANDROID_WORKSPACE=0 \
 ./configure)

# refer to https://github.com/tensorflow/tensorflow/issues/17790
# https://www.fabshop.jp/%E3%80%90step-27%E3%80%91swap%E9%A0%98%E5%9F%9F%E3%82%92%E5%88%A5%E3%83%87%E3%83%90%E3%82%A4%E3%82%B9%E3%81%AB%E7%A7%BB%E5%8B%95%E3%81%97%E3%81%A6ssd%E6%9C%80%E9%81%A9%E5%8C%96/
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/ci_build/pi/build_raspberry_pi.sh
bazel build -c opt \
      --config=monolithic \
      --copt=-DRASPBERRY_PI \
      --copt=-DS_IREAD=S_IRUSR \
      --copt=-DS_IWRITE=S_IWUSR \
      --copt=-U__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 \
      --copt=-U__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 \
      --copt=-U__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 \
      --copt=-march=armv7-a \
      --copt=-mfpu=neon-vfpv4 \
      --copt=-mfloat-abi=hard \
      --copt=-std=gnu11 \
      --copt=-funsafe-math-optimizations \
      --copt=-ftree-vectorize \
      --copt=-fomit-frame-pointer \
      --verbose_failures \
      --local_resources 1536,0.8,1.0 \
      --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
      //tensorflow:libtensorflow.so \
      //tensorflow:libtensorflow_framework.so \
      //tensorflow/tools/benchmark:benchmark_model \
      //tensorflow/tools/pip_package:build_pip_package

# https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md

bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

cd ..
D=/tmp/tensorflow_pkg/
F=tensorflow-${V}-cp35-cp35m-linux_armv7l.whl
mv $D$F release

#TODO: 
#sudo pip3 install release/$F

# Swapoff
# https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md
