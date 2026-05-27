#!/usr/bin/env bash

# Verifies a local Docker installation after setup.

set -u

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

pass() {
    printf '[PASS] %s\n' "$1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

warn() {
    printf '[WARN] %s\n' "$1"
    WARN_COUNT=$((WARN_COUNT + 1))
}

fail() {
    printf '[FAIL] %s\n' "$1"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

printf '=========================================\n'
printf ' Docker Verification\n'
printf '=========================================\n'

if command_exists docker; then
    pass "docker command found"
else
    fail "docker command not found"
fi

if command_exists docker; then
    if docker --version >/dev/null 2>&1; then
        pass "docker CLI is responding"
    else
        fail "docker CLI is installed but not responding"
    fi
fi

if command_exists systemctl; then
    if systemctl is-active --quiet docker; then
        pass "docker service is running"
    else
        fail "docker service is not running"
    fi
else
    warn "systemctl not available, skipped service check"
fi

if id -nG "$USER" | grep -qw docker; then
    pass "user '$USER' is in docker group"
else
    warn "user '$USER' is not in docker group; log out and back in after adding it"
fi

if [ -S /var/run/docker.sock ]; then
    pass "docker socket exists"
else
    fail "docker socket not found at /var/run/docker.sock"
fi

printf '\nRunning hello-world test image...\n'
if command_exists docker; then
    if docker run --rm hello-world >/dev/null 2>&1; then
        pass "hello-world container executed successfully"
    else
        fail "hello-world container failed to run"
    fi
fi

printf '\n=========================================\n'
printf ' Summary\n'
printf '=========================================\n'
printf ' Pass: %s\n' "$PASS_COUNT"
printf ' Warn: %s\n' "$WARN_COUNT"
printf ' Fail: %s\n' "$FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
    exit 1
fi
