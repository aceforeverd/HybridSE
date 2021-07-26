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
set -o nounset

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"

ARCH=$(arch)

echo "Install thirdparty ... for $(uname -a)"

# on local machine, one can tweak thirdparty path by passing extra argument
THIRDPARTY_PATH=${1:-"$ROOT/thirdparty"}
THIRDSRC_PATH="$ROOT/thirdsrc"

mkdir -p "$THIRDPARTY_PATH"
mkdir -p "$THIRDSRC_PATH"

pushd "${THIRDSRC_PATH}"

if [[ "$OSTYPE" = "darwin"* ]]; then
    curl -SLo thirdparty.tar.gz https://github.com/aceforeverd/hybridsql-asserts/releases/download/v0.4.0/thirdparty-2021-07-25-darwin-x86_64.tar.gz
    curl -SLo libzetasql.tar.gz https://github.com/aceforeverd/zetasql/releases/download/v0.2.1-beta3/libzetasql-0.2.1-beta3-darwin-x86_64.tar.gz
elif [[ "$OSTYPE" = "linux-gnu"* ]]; then
    if [[ $ARCH = 'x86_64' ]]; then
        curl -SLo thirdparty.tar.gz https://github.com/aceforeverd/hybridsql-asserts/releases/download/v0.4.0/thirdparty-2021-07-25-linux-gnu-x86_64.tar.gz
        curl -SLo libzetasql.tar.gz https://github.com/aceforeverd/zetasql/releases/download/v0.2.1-beta3/libzetasql-0.2.1-beta3-linux-gnu-x86_64.tar.gz
    elif [[ $ARCH = 'aarch64' || $ARCH = 'arm64' ]]; then
        # TODO
        curl -SLo thirdparty.tar.gz https://github.com/aceforeverd/hybridsql-asserts/releases/download/v0.4.0/thirdparty-linux-gnu-aarch64.tar.gz
    fi
fi

tar xzf thirdparty.tar.gz -C "${THIRDPARTY_PATH}" --strip-components 1
tar xzf libzetasql.tar.gz -C "${THIRDPARTY_PATH}" --strip-components 1
popd
