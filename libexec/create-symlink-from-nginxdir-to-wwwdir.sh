#!/bin/bash

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

BASEDIR=`cd $(dirname $0); pwd`
ECHO_PREFIX="[link_from_nginx_html_dir_to_www_dir]"
WWW_DIR=$BASEDIR/../www

NGINX_DIR=/usr/local/nginx-with-msgpack-rpc-module

echo "${ECHO_PREFIX} Create symlink to www dir"

if [ -d ${NGINX_DIR} ] ;then
    if [ -d ${WWW_DIR} ]; then
        sudo ln -s ${WWW_DIR} ${NGINX_DIR}
        echo
        echo "${ECHO_PREFIX} ${WWW_DIR} is linked from ${NGINX_DIR}/www"
        echo
        ls -al ${NGINX_DIR}/www
        echo
    else
        echo
        echo "${ECHO_PREFIX} ${WWW_DIR} isn't exist.."
        echo
    fi
else
    echo
    echo "${ECHO_PREFIX} ${NGINX_DIR} isn't exist.."
    echo
fi

echo "${ECHO_PREFIX} Finish !!"
