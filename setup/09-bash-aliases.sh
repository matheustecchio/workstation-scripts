#!/usr/bin/env bash
# Appends useful bash aliases (ll, gs, ga, gc, py, venv, activate, op) to ~/.bashrc.

set -eE
set -o pipefail

err_handler() {
    local log="${ERROR_LOG:-/tmp/setup-errors.$$}"
    echo "$BASH_COMMAND at '$(basename "$0"):$LINENO'" >> "$log"
}
trap err_handler ERR

cat << 'EOF' >> ~/.bashrc

# =========================
# Custom aliases
# =========================

alias ll='ls -lah'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias py='python3'
alias venv='python3 -m venv .venv'
alias activate='source .venv/bin/activate'
alias op='opencode'

EOF
