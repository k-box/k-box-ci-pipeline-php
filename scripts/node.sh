#!/usr/bin/env bash

## Original https://github.com/edbizarro/gitlab-ci-pipeline-php/blob/master/php/scripts/node.sh (c) Eduardo Bizarro
## Modification: added gdal-bin and ghostscript

set -euo pipefail

# NODE JS
curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt policy nodejs \
    && DEBIAN_FRONTEND=noninteractive apt-get install nodejs -yq \
    && npm i -g --force npm \
    && curl -o- -L https://yarnpkg.com/install.sh | bash \
    && curl -fsSL https://get.pnpm.io/install.sh | bash - \
    && npm cache clean --force

xargs sudo chmod a+x $HOME/.yarn/bin/yarn