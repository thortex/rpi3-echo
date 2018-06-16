#!/bin/sh -x

# https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md

#sudo apt-get install pkg-config zip g++ zlib1g-dev unzip
#sudo apt-get install python3-pip python3-numpy swig python3-dev
#sudo pip3 install wheel

## 2018/6/16 現在、gcc は 6.3.0 であるため、実行しない。
##sudo apt-get install gcc-4.8 g++-4.8
##sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100
##sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 100

#wget -c https://github.com/bazelbuild/bazel/releases/download/0.14.1/bazel-0.14.1-dist.zip

#unzip -d bazel bazel-0.14.1-dist.zip
cd bazel

f=scripts/bootstrap/compile.sh
x=`grep mx500M $f`
if [ "x$x" = "x" ] ; then
    sed -i 's/{JAVAC}"/{JAVAC}" -J-Xmx500M/;' $f
fi

# Bazelは32-bitはサポートしていないため、ビルドエラーが出る。
# いくつかソースを修正する
#diff -u third_party/ijar/mapped_file_unix.cc{.orig,}
#--- third_party/ijar/mapped_file_unix.cc.orig2018-06-16 10:29:34.682306745 +0900
#+++ third_party/ijar/mapped_file_unix.cc2018-06-16 10:29:50.272163155 +0900
#-  size_t mmap_length = std::min(estimated_size + sysconf(_SC_PAGESIZE),
#+  size_t mmap_length = std::min((size_t)(estimated_size + sysconf(_SC_PAGESIZE)),

sudo ./compile.sh

o=output/bazel
if [ -e "$o" ] ; then
    sudo cp $o /usr/local/bin/
fi

# https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md

