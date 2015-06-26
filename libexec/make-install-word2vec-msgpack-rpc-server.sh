#!/usr/bin/env bash

#set -x # show executed commands
set -e # die when an error will occur

BASEDIR=`cd $(dirname $0); pwd`
USER_ID=`/usr/bin/id -u`
SCRIPT="[make-install-word2vec-msgpack-rpc-server] :"

TMPDIR=/var/tmp/make-install-word2vec-msgpack-rpc-server

echo "$SCRIPT_NAME Get sudo password"
sudo pwd

echo "${SCRIPT} cd to tmp dir"
mkdir -p ${TMPDIR}
cd ${TMPDIR}

if [ -e ${TMPDIR}/word2vec-msgpack-rpc-server ]; then
    echo "${SCRIPT} cd to tmp dir"
    rm -rf ${TMPDIR}/word2vec-msgpack-rpc-server
fi

echo "${SCRIPT} cd to tmp dir"
git clone https://github.com/overlast/word2vec-msgpack-rpc-server.git
cd word2vec-msgpack-rpc-server

if [ ! -e /usr/local/lib/libmsgpack-rpc.so.1.0.0 ] || [  ! -e /usr/lib64/libjansson.so ] ; then
    echo "$SCRIPT_NAME msgpack-rpc-c++ and jansson-devel must be installed.."
    ./sh/make_centos_env.sh
fi

echo "${SCRIPT} cd to tmp dir"
./sh/compile.sh

echo "${SCRIPT} deleting ${TMPDIR}"
cd ${BASEDIR}/../
rm -rf ${TMPDIR}

echo "$SCRIPT Finish.."
