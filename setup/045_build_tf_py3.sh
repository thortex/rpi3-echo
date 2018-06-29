#!/bin/bash -x
V=1.8.0

# Retrieve the specified version of tensorflow.
wget -c https://github.com/tensorflow/tensorflow/archive/v${V}.tar.gz
tar xzf v${V}.tar.gz

# install pre-required packages.
sudo apt-get install \
     libeigen2-dev libeigen3-dev \
     libblas-dev liblapack-dev \
     libatlas-base-dev gfortran

# substitute lib for lib64.
cd tensorflow-$V && grep -Rl 'lib64' | xargs sed -i 's/lib64/lib/g'

# TODO: as-a-work-around for newer bazel/tensorflow.
sed -i 's/ ConcatCPU/ \/\/ConcatCPU/;' tensorflow/core/kernels/list_kernels.h

# A link error occurrs, if your tensorflow version is
# greater than or equal to 1.8.0.
f=third_party/png.BUILD
x=`grep PNG_ARM_NEON_OPT $f`
if [ "x$x" = "x" ] ; then
    sed -i 's/visibility /copts = ["-DPNG_ARM_NEON_OPT=0"],\n    \nvisibility /;' $f
fi

# configure
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

# build.
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

# build pip pakage.
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

R=release
cp bazel-bin/tensorflow/tools/benchmark/benchmark_model ../$R
cp bazel-bin/tensorflow/libtensorflow.so ../$R
cp bazel-bin/tensorflow/libtensorflow_framework.so ../$R

# move file to release
cd ..
D=/tmp/tensorflow_pkg/
F=tensorflow-${V}-cp35-cp35m-linux_armv7l.whl
mv $D$F $R

sudo pip3 install $R/$F

# Swapoff, if needed.
# https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md
