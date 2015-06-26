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
ECHO_PREFIX="[make-install-word2vec] :"

echo "${ECHO_PREFIX} Get sudo password"
sudo pwd

WORD2VEC_DIR=$BASEDIR/../word2vec

if [ -e $WORD2VEC_DIR ]; then
    echo "${ECHO_PREFIX} word2vec is already installed.."
else
    echo "${ECHO_PREFIX} trying to install word2vec.."
    cd $BASEDIR/../
    echo "${ECHO_PREFIX} Check out from googlecode.."
    svn checkout http://word2vec.googlecode.com/svn/trunk/ word2vec
    echo "${ECHO_PREFIX} Fix word2vec.c using patch.."
    patch $BASEDIR/../word2vec/word2vec.c  < $BASEDIR/../patch/word2vec.rev38.local.patch
    echo "${ECHO_PREFIX} Fix C++ optimal option.."
    sed -i -e "s/-OFast/-O3/g" $BASEDIR/../word2vec/makefile
    cd $BASEDIR/../word2vec/
    echo "${ECHO_PREFIX} Make.."
    make
fi

echo "${ECHO_PREFIX} Finish.."
