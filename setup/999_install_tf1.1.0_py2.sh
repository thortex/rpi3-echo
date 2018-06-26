#!/bin/sh -x
# 
# References: 
#   https://qiita.com/PonDad/items/c5419c164b4f2efee368
# 

# TODO: to support python3.x.

wget -c wget https://github.com/samjabrahams/tensorflow-on-raspberry-pi/releases/download/v1.1.0/tensorflow-1.1.0-cp27-none-linux_armv7l.whl
# wget -c wget https://github.com/samjabrahams/tensorflow-on-raspberry-pi/releases/download/v1.1.0/tensorflow-1.1.0-cp34-cp34m-linux_armv7l.whl

sudo pip install tensorflow-1.1.0-cp27-none-linux_armv7l.whl
# sudo pip3 install tensorflow-1.1.0-cp34-cp34m-linux_armv7l.whl

# For Python 2.7
sudo pip uninstall mock
sudo pip install mock
# For Python 3.3+
#sudo pip3 uninstall mock
#sudo pip3 install mock

