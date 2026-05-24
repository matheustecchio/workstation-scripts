#!/usr/bin/env bash

# Linux Workstation Setup — Orchestrator
# Runs each step script sequentially, tolerates failures,
# and reports which commands failed at the end.
# OBS: Ubuntu based distros only.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ERROR_LOG="/tmp/setup-errors.$$"
export ERROR_LOG

rm -f "$ERROR_LOG"
FAILURES=()

run_step() {
    local script="$1"
    local name="${script%.sh}"
    echo "================================================="
    echo " $name"
    echo "================================================="
    if bash "$SCRIPT_DIR/$script" 2>&1; then
        echo " OK"
    else
        echo " FAILED"
        FAILURES+=("$script")
    fi
    echo ""
}

run_step "01-system-update.sh"
run_step "02-core-packages.sh"
run_step "03-flatpak.sh"
run_step "04-npm-tools.sh"
run_step "05-vscode.sh"
run_step "06-vscode-extensions.sh"
run_step "07-docker.sh"
run_step "08-dev-folders.sh"
run_step "09-bash-aliases.sh"
run_step "10-auth-keys.sh"

echo "================================================="
if [ ${#FAILURES[@]} -eq 0 ]; then
    echo " Done!"
else
    echo " Done!"
    echo ""
    echo " Failures at:"
    if [ -s "$ERROR_LOG" ]; then
        while IFS= read -r line; do
            echo "  $line"
        done < "$ERROR_LOG"
    else
        for f in "${FAILURES[@]}"; do
            echo "  (unknown line) at '$f'"
        done
    fi
fi
echo "================================================="
echo ""
echo "IMPORTANT: Reboot your PC for all changes to take effect."
