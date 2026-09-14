#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/auto-changelog << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/auto-changelog/src/index.js "\$@"
EOF
chmod +x ${PREFIX}/bin/auto-changelog

tee ${PREFIX}/bin/auto-changelog.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\auto-changelog\src\index.js %*
EOF
