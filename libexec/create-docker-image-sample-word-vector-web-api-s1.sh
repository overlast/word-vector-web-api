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

set -eu
#set -x

BASEDIR=$(cd $(dirname $0);pwd)
SCRIPT_NAME="[create-docker-image-sample-word-vector-web-api-s1] :"

echo "${SCRIPT_NAME} Start.."

if [ "$(uname)" == 'Darwin' ] || [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then

    if [ "$(uname)" == 'Darwin' ]; then
        echo "${SCRIPT_NAME} OSX is supported"
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        echo "${SCRIPT_NAME} Linux is supported"
    else
        exit 1
    fi

    echo "${SCRIPT_NAME} cd ${BASEDIR}/../docker/sample_s1/"
    cd ${BASEDIR}/../docker/sample_s1/

    echo "${SCRIPT_NAME} docker build -t sample-word-vector-web-api-s1:v0.0.1"
    docker build -t sample-word-vector-web-api-s1:0.0.1 .

else
    echo "${SCRIPT_NAME} Your platform ($(uname -a)) isn't supported"
    exit 1
fi

echo "${SCRIPT_NAME} Finish.."
