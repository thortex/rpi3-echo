#!/bin/sh -x

wget -c https://osdn.net/projects/julius/downloads/51159/grammar-kit-v4.1.tar.gz
wget -c https://osdn.net/projects/julius/downloads/66544/dictation-kit-v4.4.zip

mkdir -p julius-kits
cd julius-kits

unzip ../dictation-kit-v4.4.zip
tar xzvf ../grammar-kit-v4.1.tar.gz
