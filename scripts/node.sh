#!/usr/bin/env bash

## Original https://github.com/edbizarro/gitlab-ci-pipeline-php/blob/master/php/scripts/node.sh (c) Eduardo Bizarro
## Modification: added gdal-bin and ghostscript

set -euo pipefail

# NODE JS
curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get install nodejs -yq \
    && npm i -g --force npm \
    && curl -o- -L https://yarnpkg.com/install.sh | bash \
    && npm cache clean --force

xargs sudo chmod a+x $HOME/.yarn/bin/yarn