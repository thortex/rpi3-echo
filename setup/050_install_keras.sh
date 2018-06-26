#!/bin/sh -x
# 
# References: 
#   https://qiita.com/PonDad/items/c5419c164b4f2efee368
# 

sudo apt-get install \
     python-scipy \
     python3-scipy \
     python-h5py \
     python3-h5py

# sudo pip install Keras
sudo pip install keras==2.1.5
sudo pip3 install keras

# TODO: switch to keras 2.1.5 APIs.
#git clone https://github.com/fchollet/deep-learning-models.git

#cd deep-learning-models
cd src
# imagenet class indices.
wget -c -O imagenet_class_index.json 'https://s3.amazonaws.com/deep-learning-models/image-models/imagenet_class_index.json'
wget -c -O imagenet_class_index_ja.json 'https://gist.githubusercontent.com/PonDad/4dcb4b242b9358e524b4ddecbee385e9/raw/dda9454f74aa4fafee991ca8b848c9ab6ae0e732/imagenet_class_index.json'

# inception_v3 trained net.
#wget -c 'https://github.com/fchollet/deep-learning-models/releases/download/v0.5/inception_v3_weights_tf_dim_ordering_tf_kernels.h5'
#wget -c 'https://github.com/fchollet/deep-learning-models/releases/download/v0.5/inception_v3_weights_tf_dim_ordering_tf_kernels_notop.h5'

# mobilenet trained net.
# TODO: migrated to v2 from v1.
# https://github.com/tensorflow/models/blob/master/research/slim/nets/mobilenet_v1.md
# https://github.com/fchollet/deep-learning-models/releases/tag/v0.6
#wget --limit-rate=50k -c 'https://github.com/fchollet/deep-learning-models/releases/download/v0.6/mobilenet_1_0_224_tf.h5'

