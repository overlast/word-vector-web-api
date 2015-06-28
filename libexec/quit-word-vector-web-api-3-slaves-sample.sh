#!/bin/bash

BASEDIR=`cd $(dirname $0); pwd`
ECHO_PREFIX="[quit-word-vector-web-api-3-slaves-sample]"

echo "${ECHO_PREFIX} Stop word2vec-server 1.."
pkill -f "model/jawiki.20150602.neologd.bin -p 22676"

echo "${ECHO_PREFIX} Stop word2vec-server 2.."
pkill -f "model/jawiki.20150602.neologd.bin -p 22677"

echo "${ECHO_PREFIX} Stop word2vec-server 3.."
pkill -f "model/jawiki.20150602.neologd.bin -p 22678"

echo "${ECHO_PREFIX} Quit nginx-master.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-master.conf -s quit

echo "${ECHO_PREFIX} Quit nginx-slave 1.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-slave1.conf -s quit

echo "${ECHO_PREFIX} Quit nginx-slave 2.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-slave2.conf -s quit

echo "${ECHO_PREFIX} Quit nginx-slave 3.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-slave3.conf -s quit

echo "${ECHO_PREFIX} Finish !!"
