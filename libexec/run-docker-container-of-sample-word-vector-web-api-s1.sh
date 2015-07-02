#!/usr/bin/env bash

# Copyright (C) 2015 Toshinori Sato (@overlast)
#
#       https://github.com/overlast/word-vector-web-api
#
# Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eu
#set -x

BASEDIR=$(cd $(dirname $0);pwd)
SCRIPT_NAME="[run-docker-container-of-sample-word-vector-web-api-s1] :"
HOST_PORT=22670

echo "${SCRIPT_NAME} Start.."

for OPT in "$@"
do
    case "$OPT" in
        '-p'|'--port' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "${SCRIPT_NAME}: option requires an argument -- $1" 1>&2
                usage
                exit 1
            fi
            HOST_PORT="$2"
            shift 2
            ;;
        -*)
            echo "${SCRIPT_NAME}: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            usage
            exit 1
            ;;
        *)
            if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                #param=( ${param[@]} "$1" )
                param+=( "$1" )
                shift 1
            fi
            ;;
    esac
done

if [ "$(uname)" == 'Darwin' ] || [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then

    if [ "$(uname)" == 'Darwin' ]; then
        echo "${SCRIPT_NAME} OSX is supported"
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        echo "${SCRIPT_NAME} Linux is supported"
    else
        exit 1
    fi

    echo "${SCRIPT_NAME} Run docker container of sample "
    docker run -d -p 0.0.0.0:${HOST_PORT}:22670 -v ${BASEDIR}/../model:/var/tmp/sample-word-vector-web-api sample-word-vector-web-api-s1:0.0.1 /bin/bash

else
    echo "${SCRIPT_NAME} Your platform ($(uname -a)) isn't supported"
    exit 1
fi

echo "${SCRIPT_NAME} Finish.."
