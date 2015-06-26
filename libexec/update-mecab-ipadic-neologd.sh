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
ECHO_PREFIX="[update-mecab-ipadic-neologd] :"
TMP_DIR=/var/tmp/mecab-ipadic-overlast

echo "${ECHO_PREFIX} Get sudo password"
sudo pwd

if [ -e $TMP_DIR ]; then
    rm -rf $TMP_DIR
fi;
mkdir $TMP_DIR
cd $TMP_DIR

git clone https://github.com/neologd/mecab-ipadic-neologd.git
cd mecab-ipadic-neologd
bin/install-mecab-ipadic-neologd -n -y

cd $BASEDIR
rm -rf $TMP_DIR

echo "${ECHO_PREFIX} Finish.."
