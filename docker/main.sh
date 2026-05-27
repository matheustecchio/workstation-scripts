#!/usr/bin/env bash

# Runs Docker helper scripts from a single menu.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ACTION="${1:-}"

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
        1|verify)
            bash "$SCRIPT_DIR/docker-verify.sh"
            ;;
        2|cleanup)
            bash "$SCRIPT_DIR/docker-cleanup.sh" "${2:-}"
            ;;
        3|init)
            bash "$SCRIPT_DIR/dockerfile-init.sh" "${2:-}" "${3:-}"
            ;;
        q|quit|exit)
            printf 'Bye\n'
            ;;
        *)
            printf 'Invalid option: %s\n' "$1" >&2
            return 1
            ;;
    esac
}

if [ -n "$ACTION" ]; then
    run_action "$@"
    exit 0
fi

print_menu
read -r -p 'Choose an option [1/2/3/q]: ' ACTION
run_action "$ACTION"
