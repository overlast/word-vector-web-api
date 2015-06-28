#!/bin/bash

BASEDIR=`cd $(dirname $0); pwd`
ECHO_PREFIX="[quit-word-vector-web-api-sample]"

echo "${ECHO_PREFIX} Stop word2vec-server.."
pkill -f "model/jawiki.20150602.neologd.bin -p 22676"

echo "${ECHO_PREFIX} Quit nginx-master.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-master-solo.conf -s quit

echo "${ECHO_PREFIX} Quit nginx-slave.."
sudo /usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c $BASEDIR/../conf/sample-word-vector-web-api-slave1.conf -s quit

echo "${ECHO_PREFIX} Finish !!"
