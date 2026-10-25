#!/usr/bin/env bash
# Configures a readable, one-way Second Brain sync to Google Drive every 5 minutes.

set -eE
set -o pipefail

err_handler() {
    local log="${ERROR_LOG:-/tmp/setup-errors.$$}"
    echo "$BASH_COMMAND at '$(basename "$0"):$LINENO'" >> "$log"
}
trap err_handler ERR

VAULT_DIR="${SECOND_BRAIN_DIR:-$HOME/Documents/Second-Brain}"
REMOTE_NAME="${SECOND_BRAIN_REMOTE:-gdrive}"
DRIVE_FOLDER="${SECOND_BRAIN_DRIVE_FOLDER:-Second Brain}"
CONFIG_DIR="$HOME/.config/rclone"
CONFIG_FILE="$CONFIG_DIR/rclone.conf"
FILTER_FILE="$CONFIG_DIR/second-brain.filter"
SYNC_SCRIPT="$HOME/.local/bin/sync-second-brain"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SYSTEMD_USER_DIR/second-brain-sync.service"
TIMER_FILE="$SYSTEMD_USER_DIR/second-brain-sync.timer"

if [ ! -d "$VAULT_DIR" ]; then
    echo "Second Brain directory not found: $VAULT_DIR" >&2
    echo "Set SECOND_BRAIN_DIR to use a different location." >&2
    exit 1
fi

if ! command -v rclone >/dev/null 2>&1; then
    echo "Installing rclone..."
    sudo apt update
    sudo apt install -y rclone
fi

mkdir -p "$CONFIG_DIR" "$HOME/.local/bin" "$SYSTEMD_USER_DIR"
chmod 700 "$CONFIG_DIR"

if ! rclone listremotes --config "$CONFIG_FILE" 2>/dev/null | grep -Fxq "$REMOTE_NAME:"; then
    echo "Google Drive remote '$REMOTE_NAME' is not configured."
    echo "Create it now and select Google Drive. Use the drive.file scope when possible."
    rclone config --config "$CONFIG_FILE"
fi

if ! rclone listremotes --config "$CONFIG_FILE" | grep -Fxq "$REMOTE_NAME:"; then
    echo "Remote '$REMOTE_NAME' was not created." >&2
    exit 1
fi

chmod 600 "$CONFIG_FILE"

cat > "$FILTER_FILE" <<'FILTERS'
- /.git/**
- /.aws/**
- /.codex/**
- /.copilot/**
- /.agents/**
- /AGENTS/**
- /.obsidian/workspace*.json
- /.obsidian/cache/**
- /.obsidian/plugins/**
- /.trash/**
- /07 - System/local/**
- /07 - System/proposals/**
- **/.env
- **/.env.*
- **/*.pem
- **/*.key
- **/*.p12
- **/*.pfx
- **/*.bundle
- **/*.zip
- **/*.tar*
FILTERS
chmod 600 "$FILTER_FILE"

cat > "$SYNC_SCRIPT" <<EOF
#!/usr/bin/env bash
set -euo pipefail

rclone copy \
    "$VAULT_DIR" \
    "$REMOTE_NAME:$DRIVE_FOLDER" \
    --filter-from "$FILTER_FILE" \
    --stats-one-line \
    --stats 5s \
    --config "$CONFIG_FILE"

rclone check \
    "$VAULT_DIR" \
    "$REMOTE_NAME:$DRIVE_FOLDER" \
    --filter-from "$FILTER_FILE" \
    --one-way \
    --config "$CONFIG_FILE"
EOF
chmod 700 "$SYNC_SCRIPT"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Sync Second Brain to Google Drive
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=$SYNC_SCRIPT
EOF

cat > "$TIMER_FILE" <<'EOF'
[Unit]
Description=Sync Second Brain to Google Drive every 5 minutes

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
Persistent=true
Unit=second-brain-sync.service

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now second-brain-sync.timer

echo "Running the initial sync..."
systemctl --user start second-brain-sync.service

echo "Second Brain sync is active."
systemctl --user list-timers second-brain-sync.timer --all --no-pager
