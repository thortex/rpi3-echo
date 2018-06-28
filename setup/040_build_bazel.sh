#!/bin/sh -x

### https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md

sudo apt-get install pkg-config zip zlib1g-dev unzip swig \
     python3-pip python3-dev \
     python-pip python-dev
sudo pip3 install wheel
sudo pip install wheel

V=0.10.0
wget -c https://github.com/bazelbuild/bazel/releases/download/${V}/bazel-${V}-dist.zip

unzip -q -d bazel bazel-${V}-dist.zip
cd bazel

f=scripts/bootstrap/compile.sh
x=`grep mx768M $f`
if [ "x$x" = "x" ] ; then
    sed -i 's/{JAVAC}"/{JAVAC}" -J-Xmx768M/;' $f
fi

# bazel > 0.10.0
#f=third_party/ijar/mapped_file_unix.cc 
#x=`grep '(estimated' $f`
#if [ "x$x" = "x" ] ; then
#    sed -i 's/min(estimated/min((size_t)estimated/;' $f
#fi
##diff -u third_party/ijar/mapped_file_unix.cc{.orig,}
##--- third_party/ijar/mapped_file_unix.cc.orig2018-06-16 10:29:34.682306745 +0900
##+++ third_party/ijar/mapped_file_unix.cc2018-06-16 10:29:50.272163155 +0900
##-  size_t mmap_length = std::min(estimated_size + sysconf(_SC_PAGESIZE),
##+  size_t mmap_length = std::min((size_t)(estimated_size + sysconf(_SC_PAGESIZE)),

f=scripts/packages/bazel.bazelrc
chmod +w $f
echo 'startup --batch_cpu_scheduling --io_nice_level 7' >> $f
echo 'build --jobs 4 --ram_utilization_factor 50' >> $f
echo 'test --jobs 4' >> $f

./compile.sh

o=output/bazel
if [ -e "$o" ] ; then
    sudo cp $o /usr/local/bin/
fi

bazel

## https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md



