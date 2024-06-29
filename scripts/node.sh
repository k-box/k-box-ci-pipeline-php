#!/usr/bin/env bash

## Original https://github.com/edbizarro/gitlab-ci-pipeline-php/blob/master/php/scripts/node.sh (c) Eduardo Bizarro
## Modification: added gdal-bin and ghostscript

set -euo pipefail

# NODE JS
mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && NODE_MAJOR=22 \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt policy nodejs && apt update \
    && DEBIAN_FRONTEND=noninteractive apt-get install nodejs -yq \
    && rm -r /etc/apt/sources.list.d/nodesource.list \
    && rm -r /etc/apt/keyrings/nodesource.gpg \
    && npm i -g --force npm \
    && curl -o- -L https://yarnpkg.com/install.sh | bash \
    && curl -fsSL https://get.pnpm.io/install.sh | bash - \
    && npm cache clean --force

xargs sudo chmod a+x $HOME/.yarn/bin/yarn