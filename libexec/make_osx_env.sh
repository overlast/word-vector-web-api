#!/usr/bin/env bash

BASEDIR=$(cd $(dirname $0);pwd)
SCRIPT_NAME="[make_osx_env] :"
TMP_DIR=/var/tmp/msgpack_rpc_c

echo "$SCRIPT_NAME Get sudo password"
sudo pwd

mkdir $TMP_DIR
cd $TMP_DIR

if [ -e /usr/local/lib/libmsgpack.so.3.0.0 ] || [ -e /usr/local/lib/libmsgpack.so.4.0.0 ]; then
    echo "$SCRIPT_NAME msgpack-c is already installed.."
else
    echo "$SCRIPT_NAME trying to install msgpack-c.."
    git clone https://github.com/msgpack/msgpack-c.git
    cd msgpack-c
    git checkout refs/tags/cpp-0.5.9
    ./bootstrap
    ./configure
    make
    sudo make install

    echo "$SCRIPT_NAME making clean msgpack-c directory.."
    cd $TMP_DIR
    rm -rf msgpack-c

    echo "$SCRIPT_NAME Refreshing the cache of shared library.."
    sudo ldconfig
fi

if [ -e /usr/local/lib/libmpio.so.0.0.0 ]; then
    echo "$SCRIPT_NAME mpio is already installed.."
else
    echo "$SCRIPT_NAME trying to install mpio.."
    git clone https://github.com/frsyuki/mpio.git
    cd mpio
    sed  -i -e "s/ -rmpl / -r.\/mpl /g" ./preprocess
    ./bootstrap
    ./configure
    make
    sudo make install

    echo "$SCRIPT_NAME making clean mpio directory.."
    cd $TMP_DIR
    rm -rf mpio

    echo "$SCRIPT_NAME Refreshing the cache of shared library.."
    sudo ldconfig
fi

if [ -e /usr/local/lib/libmsgpack-rpc.so.1.0.0 ]; then
    echo "$SCRIPT_NAME msgpack-rpc-cpp is already installed.."
else
    echo "$SCRIPT_NAME trying to install msgpack-rpc-cpp.."
    git clone https://github.com/msgpack-rpc/msgpack-rpc-cpp.git
    cd msgpack-rpc-cpp
    ./bootstrap  # if needed
    ./configure
    make
    sudo make install

    echo "$SCRIPT_NAME making clean msgpack-rpc-cpp directory.."
    cd $TMP_DIR
    rm -rf msgpack-rpc-cpp

    echo "$SCRIPT_NAME Refreshing the cache of shared library.."
    sudo ldconfig
fi

echo "$SCRIPT_NAME Making clean a build directory.."
cd $BASEDIR
rm -rf $TMP_DIR


if [ -e /usr/lib64/libjansson.so ]; then
    echo "$SCRIPT_NAME msgpack-rpc-cpp is already installed.."
else
    echo "$SCRIPT_NAME Trying to install jansson.."
    sudo yum install -y jansson jansson-devel
fi

echo "$SCRIPT_NAME Trying to install waf.."
sudo yum install -y waf



echo "$SCRIPT_NAME Finish.."
