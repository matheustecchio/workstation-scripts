#!/usr/bin/env bash
# Installs core development packages (build tools, git, languages, utilities).

set -eE
set -o pipefail

err_handler() {
    local log="${ERROR_LOG:-/tmp/setup-errors.$$}"
    echo "$BASH_COMMAND at '$(basename "$0"):$LINENO'" >> "$log"
}
trap err_handler ERR

sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    zip \
    tar \
    gzip \
    vim \
    nano \
    htop \
    btop \
    tree \
    jq \
    ripgrep \
    fd-find \
    fzf \
    tmux \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    openjdk-21-jdk \
    golang-go \
    gnome-shell-extension-manager \
    fonts-jetbrains-mono

wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > google-chrome.gpg

sudo install -D -o root -g root -m 644 \
    google-chrome.gpg \
    /etc/apt/keyrings/google-chrome.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/google-chrome.gpg] \
https://dl.google.com/linux/chrome/deb/ stable main" \
| sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

rm -f google-chrome.gpg

sudo apt update
sudo apt install -y google-chrome-stable

git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
cd ~/.bash_it && ./install.sh --silent
