#!/usr/bin/env bash

BASEDIR=$(cd $(dirname $0);pwd)
ECHO_PREFIX="[update-mecab-ipadic-neologd] :"
TMP_DIR=/var/tmp/mecab-ipadic-overlast

echo "${ECHO_PREFIX} Get sudo password"
sudo pwd

if [ -e $TMP_DIR ]; then
    rm -rf $TMP_DIR
fi;
mkdir $TMP_DIR
cd $TMP_DIR

git clone https://github.com/neologd/mecab-ipadic-neologd.git
cd mecab-ipadic-neologd
bin/install-mecab-ipadic-neologd -n -y

cd $BASEDIR
rm -rf $TMP_DIR

echo "${ECHO_PREFIX} Finish.."
