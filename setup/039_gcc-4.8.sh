#!/bin/sh -x

V=4.8

sudo apt-get install gcc-$V g++-$V

sudo unlink /usr/bin/gcc
sudo unlink /usr/bin/g++

sudo ln -s /usr/bin/gcc-4.8 /usr/bin/gcc
sudo ln -s /usr/bin/g++-4.8 /usr/bin/g++
