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
SCRIPT_NAME="[sample-model-downloader] :"
PREFIX=/usr/local

echo "$SCRIPT_NAME Start.."

if [ "$(uname)" == 'Darwin' ]; then
    echo "$SCRIPT_NAME OSX is supported"
    echo "$SCRIPT_NAME Linux is supported"

    if [ ! -d ${BASEDIR}/../tmp ]; then
        mkdir ${BASEDIR}/../tmp
    fi
    brew install -y go hg
    GOPATH=${BASEDIR}/../tmp/go go get github.com/prasmussen/gdrive/cli
    GOPATH=${BASEDIR}/../tmp/go go get github.com/voxelbrain/goptions
    GOPATH=${BASEDIR}/../tmp/go go get code.google.com/p/goauth2/oauth
    git clone https://github.com/prasmussen/gdrive.git ${BASEDIR}/../tmp/gdrive
    cd ${BASEDIR}/../tmp/gdrive
    GOPATH=${BASEDIR}/../tmp/go go build -v ./drive.go

    if [ ! -d ${BASEDIR}/../model ]; then
        mkdir ${BASEDIR}/../model
    fi
    cd ${BASEDIR}/../model/
    ${BASEDIR}/../tmp/gdrive/drive download --id 0B5QYYyltotqfM2lRQ3l4Mkc5Mk0
    unxz ./jawiki.20150602.neologd.bin.xz
    if [ ! -d /var/tmp/sample-word-vector-web-api/ ]; then
        mkdir /var/tmp/sample-word-vector-web-api/
    fi
    ln -s ${BASEDIR}/../model/jawiki.20150602.neologd.bin /var/tmp/sample-word-vector-web-api/
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    echo "$SCRIPT_NAME Linux is supported"
    if [ ! -d ${BASEDIR}/../tmp ]; then
        mkdir ${BASEDIR}/../tmp
    fi
    sudo yum install -y go hg
    echo "$SCRIPT_NAME go get github.com/prasmussen/gdrive/cli"
    GOPATH=${BASEDIR}/../tmp/go go get -v  github.com/prasmussen/gdrive/cli
    echo "$SCRIPT_NAME"
    GOPATH=${BASEDIR}/../tmp/go go get github.com/voxelbrain/goptions
    echo "$SCRIPT_NAME"
    GOPATH=${BASEDIR}/../tmp/go go get code.google.com/p/goauth2/oauth
    echo "$SCRIPT_NAME"
    git clone https://github.com/prasmussen/gdrive.git ${BASEDIR}/../tmp/gdrive
    echo "$SCRIPT_NAME"
    cd ${BASEDIR}/../tmp/gdrive
    echo "$SCRIPT_NAME"
    GOPATH=${BASEDIR}/../tmp/go go build -v ./drive.go

    if [ ! -d ${BASEDIR}/../model ]; then
        mkdir ${BASEDIR}/../model
    fi
    cd ${BASEDIR}/../model/
    echo "$SCRIPT_NAME gdrive"
    ${BASEDIR}/../tmp/gdrive/drive download --id 0B5QYYyltotqfM2lRQ3l4Mkc5Mk0
    unxz ./jawiki.20150602.neologd.bin.xz
    if [ ! -d /var/tmp/sample-word-vector-web-api/ ]; then
        mkdir /var/tmp/sample-word-vector-web-api/
    fi
    ln -s ${BASEDIR}/../model/jawiki.20150602.neologd.bin /var/tmp/sample-word-vector-web-api/
else
    echo "$SCRIPT_NAME Your platform ($(uname -a)) isn't supported"
    exit 1
fi

echo "$SCRIPT_NAME Finish.."
