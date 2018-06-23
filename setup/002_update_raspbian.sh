#!/bin/sh -x

sudo apt-get update
sudo apt-get upgrade -y 
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get clean

