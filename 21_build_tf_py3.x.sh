#!/bin/bash -x

git clone --recurse-submodules https://github.com/tensorflow/tensorflow.git

sudo apt-get install libeigen2-dev libeigen3-dev
sudo apt-get install \
     libblas-dev \
     liblapack-dev \
     libatlas-base-dev \
     python3-dev \
     python3-setuptools \
     python3-numpy \
     python3-scipy \
     python3-h5py \
     gfortran

cd tensorflow

grep -Rl 'lib64' | xargs sed -i 's/lib64/lib/g'

# ./configure
# You have bazel 0.14.1- (@non-git) installed.
# Please specify the location of python. [Default is /usr/bin/python]: /usr/bin/python3
# 
# 
# Found possible Python library paths:
# /usr/local/lib/python3.5/dist-packages
# /usr/lib/python3/dist-packages
# Please input the desired Python library path to use.  Default is [/usr/local/lib/python3.5/dist-packages]
# 
# Do you wish to build TensorFlow with jemalloc as malloc support? [Y/n]:
# jemalloc as malloc support will be enabled for TensorFlow.
# 
# Do you wish to build TensorFlow with Google Cloud Platform support? [Y/n]: n
# No Google Cloud Platform support will be enabled for TensorFlow.
# 
# Do you wish to build TensorFlow with Hadoop File System support? [Y/n]:
# Hadoop File System support will be enabled for TensorFlow.
# 
# Do you wish to build TensorFlow with Amazon S3 File System support? [Y/n]: N
# No Amazon S3 File System support will be enabled for TensorFlow.
# 
# Do you wish to build TensorFlow with Apache Kafka Platform support? [Y/n]: N
# No Apache Kafka Platform support will be enabled for TensorFlow.
# 
# Do you wish to build TensorFlow with XLA JIT support? [y/N]: N
# No XLA JIT support will be enabled for TensorFlow.
# 
# Do you wish to build TensorFlow with GDR support? [y/N]: N
# No GDR support will be enabled for TensorFlow.
# 
# Do you wish to build TensorFlow with VERBS support? [y/N]: N
# No VERBS support will be enabled for TensorFlow.
# 
# Do you wish to build TensorFlow with OpenCL SYCL support? [y/N]: N
# No OpenCL SYCL support will be enabled for TensorFlow.
# 
# Do you wish to build TensorFlow with CUDA support? [y/N]: N
# No CUDA support will be enabled for TensorFlow.
# 
# Do you wish to download a fresh release of clang? (Experimental) [y/N]: N
# Clang will not be downloaded.
# 
# Do you wish to build TensorFlow with MPI support? [y/N]: N
# No MPI support will be enabled for TensorFlow.
# 
# Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native]:
# 
# 
# Would you like to interactively configure ./WORKSPACE for Android builds? [y/N]:
# Not configuring the WORKSPACE for Android builds.
# 
# Preconfigured Bazel build configs. You can use any of the below by adding "--config=<>" to your build command. See tools/bazel.rc for more details.
# --config=mkl         # Build with MKL support.
# --config=monolithic  # Config for mostly static monolithic build.
# Configuration finished

bazel build -c opt \
      --config=monolithic \
      --cpu=armeabi-v7a \
      --copt=-mtune=cortex-a53 \
      --copt=-mcpu=cortex-a53 \
      --copt=-march=armv8-a+crc \
      --copt=-mfpu=crypto-neon-fp-armv8 \
      --copt=-funsafe-math-optimizations \
      --copt=-ftree-vectorize \
      --copt=-fomit-frame-pointer \
      --verbose_failures \
      --local_resources 1024,1.0,1.0 \
      tensorflow/tools/pip_package:build_pip_package

