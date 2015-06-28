#!/bin/bash

BASEDIR=`cd $(dirname $0); pwd`
ECHO_PREFIX="[boot-word-vector-web-api-3-slaves-sample]"

if [ ! -e /var/cache/nginx/cache ]; then
    echo "${ECHO_PREFIX} Create /var/cache/nginx/cache as cache directory.."
    sudo mkdir -p /var/cache/nginx/cache
fi

echo "${ECHO_PREFIX} Boot word2vec-server 1.."
/usr/local/bin/word2vec-msgpack-rpc-server -m $BASEDIR/../model/jawiki.20150602.neologd.bin -p 22676  > /dev/null 2>&1 &

echo "${ECHO_PREFIX} Boot word2vec-server 2.."
/usr/local/bin/word2vec-msgpack-rpc-server -m $BASEDIR/../model/jawiki.20150602.neologd.bin -p 22677  > /dev/null 2>&1 &

echo "${ECHO_PREFIX} Boot word2vec-server 3.."
/usr/local/bin/word2vec-msgpack-rpc-server -m $BASEDIR/../model/jawiki.20150602.neologd.bin -p 22678  > /dev/null 2>&1 &

echo "${ECHO_PREFIX} Boot nginx-slave 1.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-slave1.conf

echo "${ECHO_PREFIX} Boot nginx-slave 2.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-slave2.conf

echo "${ECHO_PREFIX} Boot nginx-slave 3.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-slave3.conf

echo "${ECHO_PREFIX} Boot nginx-master.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-master.conf

echo "${ECHO_PREFIX} Finish !!"
