#!/bin/bash

#!/usr/bin/env bash

#set -x # show executed commands
set -e # die when an error will occur

BASEDIR=`cd $(dirname $0); pwd`
USER_ID=`/usr/bin/id -u`
ECHO_PREFIX="[make_sample_nginx] : "

TMPDIR=/tmp/nginx-with-msgpack-rpc-module

NGX_VERSION=1.8.0
NGX_DIR_NAME=nginx-${NGX_VERSION}

NGX_DIR=nginx-with-msgpack-rpc-module
INSTALL_DIR=/usr/local/${NGX_DIR}

NGX_MODULE_DIR=${TMPDIR}/nginx-msgpack-rpc-module
ECHO_MODULE_DIR=${TMPDIR}/echo-nginx-module

echo "${ECHO_PREFIX} Get sudo password"
sudo pwd

echo "${ECHO_PREFIX} nginx will install to ${INSTALL_DIR}."

while true;do
    echo "${ECHO_PREFIX} nginx will install to ${INSTALL_DIR}."
    echo "${ECHO_PREFIX} Type 'yes|y' or 'dir path which you want to install'."
    read answer
    case $answer in
        yes)
            echo -e "${ECHO_PREFIX} [yes]\n"
            echo -e "${ECHO_PREFIX} nginx will install to ${INSTALL_DIR}.\n"
            break
            ;;
        y)
            echo -e "${ECHO_PREFIX} [y]\n"
            echo -e "${ECHO_PREFIX} nginx will install to ${INSTALL_DIR}.\n"
            break
            ;;
        *)
            echo -e "${ECHO_PREFIX} [$answer]\n"
            INSTALL_DIR=$answer
            echo -e "${ECHO_PREFIX} instll dir is changed.\n"
            ;;
    esac
done

if [ ! -e /usr/local/lib/libmsgpack_rpc_client.so.0.0.1 ]; then
    echo "${ECHO_PREFIX} msgpack-rpc-c must be installed.."
    $BASEDIR/../sh/make_centos_env.sh
fi

echo "${ECHO_PREFIX} cd to tmp dir"
if [ -e ${TMPDIR} ]; then
    rm -rf ${TMPDIR}
fi
mkdir -p ${TMPDIR}
cd ${TMPDIR}

git clone https://github.com/overlast/nginx-msgpack-rpc-module.git
git clone https://github.com/openresty/echo-nginx-module.git

wget http://nginx.org/download/${NGX_DIR_NAME}.tar.gz
tar xfvz ./${NGX_DIR_NAME}.tar.gz
cd ${NGX_DIR_NAME}

./configure --add-module=${ECHO_MODULE_DIR} --add-module=${NGX_MODULE_DIR} --prefix=${INSTALL_DIR}

${NGX_MODULE_DIR}/bin/fix_makefile.pl ./objs/Makefile
make
sudo make install

echo "${ECHO_PREFIX} nginx.conf is here => ${INSTALL_DIR}/conf/nginx.conf"
echo ""
echo "${ECHO_PREFIX} nginx with msgpack_rpc_module can start to exec ${INSTALL_DIR}/sbin/nginx"
echo "Usage :"
echo "  Start                     : ${INSTALL_DIR}/sbin/nginx"
echo "  Stop                      : ${INSTALL_DIR}/sbin/nginx -s stop"
echo "  Quit after fetch request  : ${INSTALL_DIR}/sbin/nginx -s quit"
echo "  Reopen the logfiles       : ${INSTALL_DIR}/sbin/nginx -s reopen"
echo "  Reload nginx.conf         : ${INSTALL_DIR}/sbin/nginx -s reloqd"
