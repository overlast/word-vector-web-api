#!/bin/bash

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
