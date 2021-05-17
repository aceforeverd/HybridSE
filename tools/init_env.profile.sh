#!/bin/bash
# Copyright 2021 4Paradigm
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eE

# goto the toplevel directory
pushd "$(dirname "$0")/.."

echo "CICD environment tag: ${CICD_RUNNER_TAG}"

echo "Third party packages path: ${CICD_RUNNER_THIRDPARTY_PATH}"
if [[ "$OSTYPE" == "linux-gnu"* ]]
then
    # unpack thirdparty first time
    pushd /depends
    if [[ ! -d thirdparty && -r thirdparty.tar.gz ]]; then
        tar xzf thirdparty.tar.gz
        mv thirdparty-*/ thirdparty
    fi
    popd

    ln -sf /depends/thirdparty thirdparty

    # TODO: delete the 'source' code. Those code is just a double-ensure that rh tools are enabled.
    #  It is specific to docker development environment and therefore should ensured by docker image.
    if [ -r /opt/rh/devtoolset-7/enable ]; then
        # shellcheck disable=SC1091
        source /opt/rh/devtoolset-7/enable
    fi
    if [ -r /opt/rh/sclo-git212/enable ]; then
        # shellcheck disable=SC1091
        source /opt/rh/sclo-git212/enable
    fi
    if [ -r /opt/rh/rh-git218/enable ]; then
        # shellcheck disable=SC1091
        source /opt/rh/rh-git218/enable
    fi
    if [ -r /opt/rh/python27/enable ]; then
        # shellcheck disable=SC1091
        source /opt/rh/python27/enable
    fi
    if [ -r /opt/rh/rh-python38/enable ]; then
        # shellcheck disable=SC1091
        source /opt/rh/rh-python38/enable
    fi

    if [ -r /etc/profile.d/enable-thirdparty.sh ]; then
        # shellcheck disable=SC1091
        source /etc/profile.d/enable-thirdparty.sh
    else
        # backward configure for old environment
        export JAVA_HOME=${PWD}/thirdparty/jdk1.8.0_141
        export PATH=${PWD}/thirdparty/bin:$JAVA_HOME/bin:${PWD}/thirdparty/apache-maven-3.6.3/bin:$PATH
    fi
else
    # shellcheck disable=SC1090
    source ~/.bash_profile
    ln -sf "${CICD_RUNNER_THIRDPARTY_PATH}" thirdparty
fi
popd
