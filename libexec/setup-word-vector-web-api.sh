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

echo "$SCRIPT_NAME Install nginx-with-msgpack-rpc-moulle"
$BASEDIR/../libexec/make-install-nginx-with-msgpack-rpc-moulle.sh

echo "$SCRIPT_NAME Create symlink to www dir from nginx-with-msgpack-rpc-moulle dir"
$BASEDIR/../libexec/create_symlink_from_nginxdir_to_wwwdir.sh

echo "$SCRIPT_NAME Install word2vec-msgpack-rpc-server"
$BASEDIR/../libexec/make-install-word2vec-msgpack-rpc-server.sh

echo "$SCRIPT_NAME Install mecab and mecab-ipadic"
$BASEDIR/../libexec/install-mecab-and-mecab-ipadic.sh

echo "$SCRIPT_NAME Install mecab-ipadic-overlast"
$BASEDIR/../libexec/update-mecab-ipadic-neologd.sh

echo "$SCRIPT_NAME Install word2vec"
$BASEDIR/../libexec/make-install-word2vec.sh

echo "$SCRIPT_NAME Finish.."
