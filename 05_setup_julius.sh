#!/bin/sh -x

wget -c wget https://ja.osdn.net/projects/julius/downloads/66547/julius-4.4.2.tar.gz

tar xzvf julius-4.4.2.tar.gz

cd julius-4.4.2

export CFLAGS='-O3 -mtune=cortex-a53 -march=armv8-a+crc -mcpu=cortex-a53 -mfpu=crypto-neon-fp-armv8'
./configure \
    --enable-zlib \
    --enable-neon \
    --enable-pthread \
    --enable-fork 

make 

sudo apt-get install \
  checkinstall \
  manpages-ja

sudo mkdir -p /usr/local/share/man/ja

sudo checkinstall

cd ..

wget https://osdn.net/projects/julius/downloads/51159/grammar-kit-v4.1.tar.gz
wget https://osdn.net/projects/julius/downloads/66544/dictation-kit-v4.4.zip

mkdir julius-kits
cd julius-kits

unzip ../dictation-kit-v4.4.zip
tar xzvf ../grammar-kit-v4.1.tar.gz










 
