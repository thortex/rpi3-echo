#!/bin/sh -x

R=v0.0.1
V=4.4.2

U=https://github.com/thortex/rpi3-echo/releases/download/
F=${U}${R}/julius_${V}-1_armhf.deb

wget -c $F

sudo dpkg -i $F
