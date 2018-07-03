#!/bin/bash -x
APACHE_ARROW_VER=0.9.0
PARQUET_VER=1.4.0
TF_POSE_VER=0.1.0
U=https://www.piwheels.org/simple/
ARCH=armv7l
PY_VER=35
# install an architecture-dependent wheel.
function install_arch_dep_whl() {
    sudo pip3 install ${U}${1}/${2}-${3}-cp${PY_VER}-cp${PY_VER}m-linux_${ARCH}.whl
}
# install an architecture-independent wheel.
function install_arch_indep_whl() {
    sudo pip3 install ${U}${1}/${2}-${3}-py2.py3-none-any.whl
}
# install an architecture-independent wheel related for only python3.
function install_arch_indep_whl3() {
    sudo pip3 install ${U}${1}/${2}-${3}-py3-none-any.whl
}
# install pre-required wheels.
function install_pre_required_wheels() {
    install_arch_indep_whl tqdm tqdm 4.23.4;
    install_arch_dep_whl cython Cython 0.28.3;
    install_arch_indep_whl argparse argparse 1.4.0;
    install_arch_indep_whl3 dill dill 0.2.7.1;
    install_arch_indep_whl six six 1.11.0;
    install_arch_indep_whl fire fire 0.1.3;
    install_arch_indep_whl chardet chardet 3.0.4;
    install_arch_indep_whl urllib3 urllib3 1.23;
    install_arch_indep_whl certifi certifi 2018.4.16;
    install_arch_indep_whl idna idna 2.7;
    install_arch_dep_whl psutil psutil 5.4.6;
    install_arch_indep_whl requests requests 2.19.1;
    install_arch_dep_whl pyzmq pyzmq 17.0.0;
    install_arch_dep_whl numpy numpy 1.14.5;
    install_arch_dep_whl scipy scipy 1.1.0;
    install_arch_indep_whl slidingwindow slidingwindow 0.0.13;
    install_arch_dep_whl pywavelets PyWavelets 0.5.2;
    install_arch_indep_whl networkx networkx 2.1;
    install_arch_indep_whl decorator decorator 4.3.0;
    install_arch_dep_whl scikit-image scikit_image 0.13.1;
    install_arch_indep_whl python-dateutil python_dateutil 2.7.3;
    install_arch_indep_whl pytz pytz 2018.5;
    install_arch_dep_whl kiwisolver kiwisolver 1.0.1;
    install_arch_indep_whl cycler cycler 0.10.0;
    install_arch_indep_whl pyparsing pyparsing 2.2.0;
    install_arch_dep_whl matplotlib matplotlib 2.2.2;
    install_arch_indep_whl3 tabulate tabulate 0.8.1;
}
# build and install Apache arrow debian package.
function install_apache_arrow()
{
    V=$1
    ARROW_BUILD_TYPE=Release
    F=apache-arrow-${V}.tar.gz
    MIRROR=http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/arrow/
    wget -c ${MIRROR}arrow-${V}/${F}
    tar xzf apache-arrow-$V.tar.gz
    cd apache-arrow-$V
    sudo apt-get install cmake flex bison \
	      libboost-dev \
	      libboost-system-dev \
	      libboost-filesystem-dev \
	      libboost-regex-dev \
	      libgtest-dev libgoogle-glog-dev libgflags-dev \
	      libjemalloc-dev 
    cd cpp && mkdir -p build && cd build
    cmake .. \
	  -DCMAKE_BUILD_TYPE=$ARROW_BUILD_TYPE \
	  -DARROW_PYTHON=on \
	  -DARROW_BUILD_TESTS=OFF \
	  -DPYTHON_EXECUTABLE=/usr/bin/python3.5
    make && sudo checkinstall -D \
	 --install=yes \
	 --pkgname=apache-arrow \
	 --provides=apache-arrow \
	 --pkgversion=$V 
    cd ../../..
    sudo ldconfig
}
# build and install Apache Parquet debian package.
function install_apache_parquet()
{
    SSL_VER=1.0
    F=apache-parquet-cpp-${PARQUET_VER}.tar.gz
    MIRROR=http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/parquet/apache-parquet-cpp-${PARQUET_VER}/$F
    wget -c $MIRROR
    tar xzf $F
    cd apache-parquet-cpp-${PARQUET_VER}

    sudo apt-get install libtool bison flex pkg-config \
	 libboost-dev libboost-filesystem-dev \
	 libboost-program-options-dev \
	 libboost-regex-dev libboost-system-dev \
	 libboost-test-dev libssl${SSL_VER}-dev

    mkdir -p build && \
	cd build && \
	cmake -DCMAKE_BUILD_TYPE=$ARROW_BUILD_TYPE \
	      -DPARQUET_BUILD_BENCHMARKS=off \
	      -DPARQUET_BUILD_EXECUTABLES=off \
	      -DPARQUET_BUILD_TESTS=off \
	      .. && \
	make && \
	sudo checkinstall -D \
	     --install=yes \
	     --pkgname=apache-parquet-cpp \
	     --provides=apache-parquet-cpp \
	     --pkgversion=${PARQUET_VER}  && \
	cd ../..
}
# build and install pyarrow wheel.
function install_pyarrow() {
    V=$1
    F=pyarrow-${V}-cp35-cp35m-linux_armv7l.whl
    cd apache-arrow-$V/python && \
	python3 setup.py bdist_wheel && \
	mv dist/$F ../../../release
    cd ../../
    sudo pip3 install ../release/$F    
}

install_pre_required_wheels;
git clone https://github.com/ildoonet/tf-pose-estimation
cd tf-pose-estimation
install_apache_arrow $APACHE_ARROW_VER;
install_apache_parquet;
install_pyarrow $APACHE_ARROW_VER;

# exclude the cmu graph model.
sed -i 's/^subprocess/#subprocess/;' setup.py
# fake cmu model.
touch models/graph/cmu/graph_opt.pb
# build wheel package
python3 setup.py bdist_wheel

F=tf_pose-${TF_POSE_VER}-cp35-cp35m-linux_armv7l.whl
mv dist/$F ../release
sudo pip3 install ../release/$F
