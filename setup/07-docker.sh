#!/usr/bin/env bash
# Installs Docker CE using Ubuntu Noble repos (compatible with Mint 22.x).

set -eE
set -o pipefail

err_handler() {
    local log="${ERROR_LOG:-/tmp/setup-errors.$$}"
    echo "$BASH_COMMAND at '$(basename "$0"):$LINENO'" >> "$log"
}
trap err_handler ERR

sudo rm -f /etc/apt/sources.list.d/docker.list

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

DEFAULT_UBUNTU_CODENAME="noble"
read -r -p "Ubuntu codename (default: $DEFAULT_UBUNTU_CODENAME): " UBUNTU_CODENAME
UBUNTU_CODENAME="${UBUNTU_CODENAME:-$DEFAULT_UBUNTU_CODENAME}" # Use default if empty


echo \
"deb [arch=$(dpkg --print-architecture) \
signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu \
${UBUNTU_CODENAME} stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

sudo usermod -aG docker $USER

sudo systemctl enable docker
