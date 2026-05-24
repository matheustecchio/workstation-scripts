#!/usr/bin/env bash
# Installs global npm CLI tools (yarn, pnpm, typescript, eslint, prettier, opencode-ai).

set -eE
set -o pipefail

err_handler() {
    local log="${ERROR_LOG:-/tmp/setup-errors.$$}"
    echo "$BASH_COMMAND at '$(basename "$0"):$LINENO'" >> "$log"
}
trap err_handler ERR

sudo npm install -g \
    yarn \
    pnpm \
    typescript \
    ts-node \
    eslint \
    prettier \
    opencode-ai
