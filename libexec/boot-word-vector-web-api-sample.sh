#!/bin/bash

BASEDIR=`cd $(dirname $0); pwd`
ECHO_PREFIX="[boot-word-vector-web-api-sample]"

if [ ! -e /var/cache/nginx/cache ]; then
    echo "${ECHO_PREFIX} Create /var/cache/nginx/cache as cache directory.."
    sudo mkdir -p /var/cache/nginx/cache
fi

echo "${ECHO_PREFIX} Boot word2vec-server.."
/usr/local/bin/word2vec-msgpack-rpc-server -m $BASEDIR/../model/jawiki.20150602.neologd.bin -p 22676  > /dev/null 2>&1 &

echo "${ECHO_PREFIX} Boot nginx-slave.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-slave1.conf

echo "${ECHO_PREFIX} Boot nginx-master.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-master-solo.conf

echo "${ECHO_PREFIX} Finish !!"
