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
SCRIPT_NAME="[sample-model-downloader] :"
PREFIX=/usr/local

echo "${SCRIPT_NAME} Start.."

if [ "$(uname)" == 'Darwin' ] || [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    if [ "$(uname)" == 'Darwin' ]; then
            echo "${SCRIPT_NAME} OSX is supported"
            if [ ! -d ${BASEDIR}/../tmp ]; then
                mkdir ${BASEDIR}/../tmp
            fi
            brew install -y go hg
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
            echo "${SCRIPT_NAME} Linux is supported"
            if [ ! -d ${BASEDIR}/../tmp ]; then
                echo "${SCRIPT_NAME} mkdir ${BASEDIR}/../tmp"
                mkdir ${BASEDIR}/../tmp
            fi
            echo "${SCRIPT_NAME} Install go and hg"
            sudo yum install -y go hg
    else
        exit 1
    fi

    echo "${SCRIPT_NAME} go get github.com/prasmussen/gdrive/cli"
    GOPATH=${BASEDIR}/../tmp/go go get -v github.com/prasmussen/gdrive/cli
    echo "${SCRIPT_NAME} go get github.com/voxelbrain/goptions"
    GOPATH=${BASEDIR}/../tmp/go go get -v github.com/voxelbrain/goptions
    echo "${SCRIPT_NAME} go get code.google.com/p/goauth2/oauth"
    GOPATH=${BASEDIR}/../tmp/go go get -v code.google.com/p/goauth2/oauth
    echo "${SCRIPT_NAME} git clone https://github.com/prasmussen/gdrive.git"
    git clone https://github.com/prasmussen/gdrive.git ${BASEDIR}/../tmp/gdrive
    echo "${SCRIPT_NAME} cd ${BASEDIR}/../tmp/gdrive"
    cd ${BASEDIR}/../tmp/gdrive
    echo "${SCRIPT_NAME} Compile drive.go to create Google Drive CLI application"
    GOPATH=${BASEDIR}/../tmp/go go build -v ./drive.go

    if [ ! -d ${BASEDIR}/../model ]; then
        echo "${SCRIPT_NAME} mkdir ${BASEDIR}/../model"
        mkdir ${BASEDIR}/../model
    fi

    echo "${SCRIPT_NAME} cd ${BASEDIR}/../model/"
    cd ${BASEDIR}/../model/
    echo "${SCRIPT_NAME} Download sample model data file from Google Drive using drive command"
    ${BASEDIR}/../tmp/gdrive/drive download --id 0B5QYYyltotqfM2lRQ3l4Mkc5Mk0

    if [ -e ${BASEDIR}/../model/jawiki.20150602.neologd.bin ]; then
        echo "${SCRIPT_NAME} Delete old sample model file"
        rm ${BASEDIR}/../model/jawiki.20150602.neologd.bin
    fi

    echo "${SCRIPT_NAME} Decompress sample model data file using unxz command"
    unxz ./jawiki.20150602.neologd.bin.xz

else
    echo "${SCRIPT_NAME} Your platform ($(uname -a)) isn't supported"
    exit 1
fi

echo "${SCRIPT_NAME} Finish.."
