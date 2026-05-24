#!/usr/bin/env bash
# Installs VS Code extensions (Python, Go, Docker, GitLens, Prettier, ESLint, Copilot, remote containers).

set -eE
set -o pipefail

err_handler() {
    local log="${ERROR_LOG:-/tmp/setup-errors.$$}"
    echo "$BASH_COMMAND at '$(basename "$0"):$LINENO'" >> "$log"
}
trap err_handler ERR

code --install-extension ms-python.python || true
code --install-extension ms-python.vscode-pylance || true
code --install-extension golang.go || true
code --install-extension ms-azuretools.vscode-docker || true
code --install-extension eamodio.gitlens || true
code --install-extension esbenp.prettier-vscode || true
code --install-extension dbaeumer.vscode-eslint || true
code --install-extension github.copilot || true
code --install-extension github.copilot-chat || true
code --install-extension ms-vscode-remote.remote-containers || true
