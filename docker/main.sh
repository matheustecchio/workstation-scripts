#!/usr/bin/env bash

# Runs Docker helper scripts from a single menu.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

print_menu() {
    printf '=========================================\n'
    printf ' Docker Tools\n'
    printf '=========================================\n'
    printf '  1) Verify Docker setup\n'
    printf '  2) Cleanup Docker resources\n'
    printf '  3) Generate a Dockerfile\n'
    printf '  q) Quit\n'
}

run_action() {
    case "$1" in
        1)
            bash "$SCRIPT_DIR/docker-verify.sh"
            ;;
        2)
            bash "$SCRIPT_DIR/docker-cleanup.sh"
            ;;
        3)
            bash "$SCRIPT_DIR/dockerfile-init.sh"
            ;;
        q|Q)
            printf 'Bye\n'
            return 1
            ;;
        *)
            printf 'Invalid option: %s\n' "$1" >&2
            ;;
    esac
}

while true; do
    print_menu
    read -r -p 'Choose an option [1/2/3/q]: ' ACTION
    if ! run_action "$ACTION"; then
        break
    fi

    printf '\n'
    read -r -p 'Press ENTER to return to the menu...'
    printf '\n'
done
