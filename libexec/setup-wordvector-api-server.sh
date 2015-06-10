#!/usr/bin/env bash

BASEDIR=$(cd $(dirname $0);pwd)
SCRIPT_NAME="[setup-wordvector-api-server] :"

echo "$SCRIPT_NAME Get sudo password"
sudo pwd

echo "$SCRIPT_NAME Install nginx-with-msgpack-rpc-moulle"
$BASEDIR/../libexec/make-install-nginx-with-msgpack-rpc-moulle.sh

echo "$SCRIPT_NAME Create symlink to www dir from nginx-with-msgpack-rpc-moulle dir"
$BASEDIR/../libexec/create_symlink_from_nginx_dir_to_www_dir.sh

echo "$SCRIPT_NAME Install word2vec-msgpack-rpc-server"
$BASEDIR/../libexec/make-install-word2vec-msgpack-rpc-server.sh

echo "$SCRIPT_NAME Install mecab and mecab-ipadic"
$BASEDIR/../libexec/install-mecab-and-mecab-ipadic.sh

echo "$SCRIPT_NAME Install mecab-ipadic-overlast"
$BASEDIR/../libexec/update-mecab-ipadic-overlast.sh

echo "$SCRIPT_NAME Install word2vec"
$BASEDIR/../libexec/make-install-word2vec.sh

echo "$SCRIPT_NAME Finish.."
