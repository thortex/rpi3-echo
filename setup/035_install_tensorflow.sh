#!/bin/sh -x
# 
# References:
# https://github.com/lhelontra/tensorflow-on-arm/

V=1.8.0
B=armv7l
URL=https://github.com/lhelontra/tensorflow-on-arm/releases/download/

WHEEL_2=tensorflow-${V}-cp27-none-linux_${B}.whl
WHEEL_3=tensorflow-${V}-cp35-none-linux_${B}.whl

wget -c ${URL}v$V/${WHEEL_2}
wget -c ${URL}v$V/${WHEEL_3}

sudo pip2 install mock --upgrade
sudo pip3 install mock --upgrade

sudo pip2 install ${WHEEL_2}
sudo pip3 install ${WHEEL_3}

sync && sync && sync 
