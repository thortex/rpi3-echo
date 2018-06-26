#!/bin/sh -x

install_required_pkgs()
{
    V=$1
    
    sudo apt-get install \
	 python${V}-setuptools \
	 python${V}-wheel \
	 python${V}-six \
	 python${V}-dev \
	 python${V}-setuptools \
	 python${V}-scipy \
	 python${V}-h5py 

    # latest version of numpy is required.
    sudo pip${V} install numpy --upgrade

    sudo pip${V} install \
	 grpcio \
	 ptorobuf \
	 gast \
	 astor \
	 absl-py \
	 markdown \
	 termcolor 
}

install_required_pkgs "";
install_required_pkgs 3;

