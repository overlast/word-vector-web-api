#!/usr/bin/env bash

# Copyright (C) 2015 Toshinori Sato (@overlast)
#
#       https://github.com/overlast/word-vector-web-api
#
# Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#set -x # show executed commands
set -e # die when an error will occur

BASEDIR=`cd $(dirname $0); pwd`
USER_ID=`/usr/bin/id -u`
ECHO_PREFIX="[make-install-word2vec-msgpack-rpc-server] :"

TMPDIR=/var/tmp/make-install-word2vec-msgpack-rpc-server

echo "${ECHO_PREFIX} Get sudo password"
sudo pwd

echo "${ECHO_PREFIX} cd to tmp dir"
if [ -e ${TMPDIR} ]; then
    rm -rf ${TMPDIR}
fi
mkdir -p ${TMPDIR}
cd ${TMPDIR}

if [ -e ${TMPDIR}/word2vec-msgpack-rpc-server ]; then
    echo "${ECHO_PREFIX} cd to tmp dir"
    rm -rf ${TMPDIR}/word2vec-msgpack-rpc-server
fi

echo "${ECHO_PREFIX} cd to tmp dir"
git clone https://github.com/overlast/word2vec-msgpack-rpc-server.git
cd word2vec-msgpack-rpc-server

if [ ! -e /usr/local/lib/libmsgpack-rpc.so.1.0.0 ] || [  ! -e /usr/lib64/libjansson.so ] ; then
    echo "${ECHO_PREFIX} msgpack-rpc-c++ and jansson-devel must be installed.."
    ./sh/make_centos_env.sh
fi

echo "${ECHO_PREFIX} cd to tmp dir"
./sh/compile.sh

echo "${ECHO_PREFIX} deleting ${TMPDIR}"
cd ${BASEDIR}/../
rm -rf ${TMPDIR}

INSTALL_DIR=/usr/local
SCRIPT=word2vec-msgpack-rpc-server

echo "${ECHO_PREFIX} Finish.."
echo

echo "${ECHO_PREFIX} ${SCRIPT} is here => ${INSTALL_DIR}/bin/word2vec-msgpack-rpc-server"
ls -al ${INSTALL_DIR}/bin/word2vec-msgpack-rpc-server
echo
echo "${ECHO_PREFIX} nginx with msgpack_rpc_module can start to exec ${INSTALL_DIR}/bin/word2vec-msgpack-rpc-server"
echo "Usage :"
echo "  Start : ${INSTALL_DIR}/bin/word2vec-msgpack-rpc-server -m [/path/to/word/vector/model] -p [port_number]"
echo
