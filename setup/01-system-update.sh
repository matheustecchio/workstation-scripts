#!/usr/bin/env bash
# Updates package lists and upgrades all system packages.

set -eE
set -o pipefail

err_handler() {
    local log="${ERROR_LOG:-/tmp/setup-errors.$$}"
    echo "$BASH_COMMAND at '$(basename "$0"):$LINENO'" >> "$log"
}
trap err_handler ERR

sudo apt update
sudo apt upgrade -y
