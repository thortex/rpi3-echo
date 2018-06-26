#!/bin/sh -x

sudo apt-get install \
     python-scipy python3-scipy \
     python-h5py  python3-h5py

# sudo pip install Keras
sudo pip install keras
sudo pip3 install keras

cd src

E=imagenet_class_index.json
wget -c -O ${E} 'https://s3.amazonaws.com/deep-learning-models/image-models/imagenet_class_index.json'

J=imagenet_class_index_ja.json
wget -c -O ${J} 'https://gist.githubusercontent.com/PonDad/4dcb4b242b9358e524b4ddecbee385e9/raw/dda9454f74aa4fafee991ca8b848c9ab6ae0e732/imagenet_class_index.json'

