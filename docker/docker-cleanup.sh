#!/usr/bin/env bash

# Cleans Docker resources using a safe or full mode.

set -euo pipefail

MODE="${1:-}"

if ! command -v docker >/dev/null 2>&1; then
    printf 'docker command not found\n' >&2
    exit 1
fi

if [ -z "$MODE" ]; then
    printf 'Cleanup mode:\n'
    printf '  1) safe  - stopped containers, dangling images, build cache\n'
    printf '  2) full  - all unused images, networks, cache, and volumes\n'
    read -r -p 'Choose mode [safe/full]: ' MODE
fi

case "$MODE" in
    safe|full)
        ;;
    *)
        printf 'Usage: %s [safe|full]\n' "$(basename "$0")" >&2
        exit 1
        ;;
esac

printf '=========================================\n'
printf ' Docker Disk Usage\n'
printf '=========================================\n'
docker system df

printf '\n'
read -r -p "Proceed with '$MODE' cleanup? [y/N]: " CONFIRM

case "$CONFIRM" in
    y|Y|yes|YES)
        ;;
    *)
        printf 'Cleanup cancelled\n'
        exit 0
        ;;
esac

if [ "$MODE" = "safe" ]; then
    docker container prune -f
    docker image prune -f
    docker builder prune -f
else
    docker system prune -a --volumes -f
fi

printf '\n=========================================\n'
printf ' Docker Disk Usage After Cleanup\n'
printf '=========================================\n'
docker system df
