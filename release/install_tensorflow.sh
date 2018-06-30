#!/bin/sh -x

U=https://github.com/thortex/rpi3-echo/releases/download/
R=v0.0.1
V=1.8.0
F=${U}${R}/tensorflow-${V}-cp35-cp35m-linux_armv7l.whl

wget -c $F
sudo pip3 install $F

F=${U}${R}/tensorflow-${V}-cp27-cp27mu-linux_armv7l.whl
wget -c $F
sudo pip2 install $F
