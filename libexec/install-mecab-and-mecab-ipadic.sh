#!/usr/bin/env bash

BASEDIR=$(cd $(dirname $0);pwd)
ECHO_PREFIX="[install-mecab-and-mecab-ipadic] :"

echo "${ECHO_PREFIX} Get sudo password"
sudo pwd

sudo rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
sudo yum install -y mecab mecab-devel mecab-ipadic

echo "${ECHO_PREFIX} Finish.."
