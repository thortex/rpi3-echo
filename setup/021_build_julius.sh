#!/bin/sh -x
V=4.4.2

wget -c wget https://ja.osdn.net/projects/julius/downloads/66547/julius-${V}.tar.gz
tar xzvf julius-${V}.tar.gz
cd julius-${V}

(CFLAGS='-O3 -mtune=cortex-a53 -march=armv8-a+crc -mcpu=cortex-a53 -mfpu=crypto-neon-fp-armv8' \
    ./configure \
    --enable-zlib \
    --enable-neon \
    --enable-pthread \
    --enable-fork )

make 

sudo apt-get install manpages-ja

sudo mkdir -p /usr/local/share/man/ja

sudo checkinstall

cd ..
