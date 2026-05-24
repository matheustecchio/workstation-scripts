#!/usr/bin/env bash
# Installs Flatpak and adds the Flathub remote repository.

set -eE
set -o pipefail

err_handler() {
    local log="${ERROR_LOG:-/tmp/setup-errors.$$}"
    echo "$BASH_COMMAND at '$(basename "$0"):$LINENO'" >> "$log"
}
trap err_handler ERR

sudo apt install -y flatpak

flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub \
    com.discordapp.Discord
