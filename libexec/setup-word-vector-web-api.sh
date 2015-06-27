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

BASEDIR=$(cd $(dirname $0);pwd)
SCRIPT_NAME="[setup-wordvector-api-server] :"
PREFIX=/usr/local

echo "$SCRIPT_NAME Start.."

if [ "$(uname)" == 'Darwin' ]; then
    echo "$SCRIPT_NAME OSX is supported"
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    echo "$SCRIPT_NAME Linux is supported"
else
    echo "$SCRIPT_NAME Your platform ($(uname -a)) isn't supported"
    exit 1
fi

echo "$SCRIPT_NAME Get sudo password"
sudo pwd

NGXWMPRPCM_DIR=${PREFIX}/nginx-with-msgpack-rpc-module
if [ -d ${NGXWMPRPCM_DIR} ]; then
        echo "$SCRIPT_NAME nginx-with-msgpack-rpc-moulle is already installed"
else
    echo "$SCRIPT_NAME Install nginx-with-msgpack-rpc-moulle"
    $BASEDIR/../libexec/make-install-nginx-with-msgpack-rpc-moulle.sh
fi

WWW_DIR_PATH=${NGXWMPRPCM_DIR}/www
if [ -e ${WWW_DIR_PATH} ]; then
        echo "$SCRIPT_NAME symlink to www dir from nginx-with-msgpack-rpc-moulle dir is already created"
else
    echo "$SCRIPT_NAME Create symlink to www dir from nginx-with-msgpack-rpc-moulle dir"
    $BASEDIR/../libexec/create_symlink_from_nginxdir_to_wwwdir.sh
fi

W2VMPRPCS_PATH=`which word2vec-msgpack-rpc-server`
if [ -e ${W2VMPRPCS_PATH} ]; then
    echo "$SCRIPT_NAME word2vec-msgpack-rpc-server is already installed"
else
    echo "$SCRIPT_NAME Install word2vec-msgpack-rpc-server"
    $BASEDIR/../libexec/make-install-word2vec-msgpack-rpc-server.sh
fi

MECAB_PATH=`which mecab`
MECAB_DIC_DIR=`${MECAB_PATH}-config --dicdir`
MECAB_IPADIC_DIR=${MECAB_DIC_DIR}/ipadic
if [ -e ${MECAB_PATH}-config ] && [ -d ${MECAB_IPADIC_DIR} ]; then
    echo "$SCRIPT_NAME MeCab and mecab-ipadic is already installed"
else
    echo "$SCRIPT_NAME Install MeCab and mecab-ipadic"
    $BASEDIR/../libexec/install-mecab-and-mecab-ipadic.sh
fi

MECAB_PATH=`which mecab`
MECAB_DIC_DIR=`${MECAB_PATH}-config --dicdir`
MECAB_IPADIC_NEOLOGD_DIR=${MECAB_DIC_DIR}/mecab-ipadic-neologd
if [ -d ${MECAB_IPADIC_NEOLOGD_DIR} ]; then
    echo "$SCRIPT_NAME mecab-ipadic-NEologd is already installed"
else
    echo "$SCRIPT_NAME Install mecab-ipadic-NEologd"
    $BASEDIR/../libexec/update-mecab-ipadic-neologd.sh
fi

WORD2VEC_DIR=$BASEDIR/../word2vec
if [ -d ${WORD2VEC_DIR} ]; then
    echo "$SCRIPT_NAME Word2Vec is already installed"
else
    echo "$SCRIPT_NAME Install Word2Vec"
    $BASEDIR/../libexec/make-install-word2vec.sh
fi

echo "$SCRIPT_NAME Finish.."
