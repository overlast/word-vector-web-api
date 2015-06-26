#!/usr/bin/env bash

BASEDIR=$(cd $(dirname $0);pwd)
SCRIPT_NAME="[install-mecab-and-mecab-ipadic] :"

echo "$SCRIPT_NAME Get sudo password"
sudo pwd

sudo rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
sudo yum install -y mecab mecab-devel mecab-ipadic

echo "$SCRIPT_NAME Finish.."
