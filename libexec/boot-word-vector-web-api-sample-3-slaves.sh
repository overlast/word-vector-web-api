#!/bin/bash

/usr/local/bin/word2vec-msgpack-rpc-server -m /var/tmp/sample-word-vector-web-api/jawiki.20150602.neologd.bin -p 22676 > /dev/null 2>&1 &
/usr/local/bin/word2vec-msgpack-rpc-server -m /var/tmp/sample-word-vector-web-api/jawiki.20150602.neologd.bin -p 22677 > /dev/null 2>&1 &
/usr/local/bin/word2vec-msgpack-rpc-server -m /var/tmp/sample-word-vector-web-api/jawiki.20150602.neologd.bin -p 22678 > /dev/null 2>&1 &

/usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c /root/git/word-vector-web-api/conf/sample-word-vector-web-api-slave1.conf
/usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c /root/git/word-vector-web-api/conf/sample-word-vector-web-api-slave2.conf
/usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c /root/git/word-vector-web-api/conf/sample-word-vector-web-api-slave3.conf

/usr/local/nginx-with-msgpack-rpc-module/sbin/nginx -c /root/git/word-vector-web-api/conf/sample-word-vector-web-api-master.conf

while true
do
    sleep 86400
done
