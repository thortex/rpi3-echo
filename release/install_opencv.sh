#!/bin/sh -x

U=https://github.com/thortex/rpi3-echo/releases/download/
R=v0.0.1
V=3.4.1-20180623

F=${U}${R}/opencv_${V}-1_armhf.deb

wget -c $F

sudo dpkg -i $F
