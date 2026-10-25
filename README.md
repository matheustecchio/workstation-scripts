# workstation-scripts

Simple scripts to set up my Ubuntu/Linux Mint workstation.

## Content

- `setup/`: install packages, Docker, VS Code, aliases, and import auth keys
- `docker/`: verify Docker, clean Docker resources, generate starter Dockerfiles, and run these tools from a menu
- `merge_repo.sh`: merge another git repository into a subfolder

## Setup Scripts

- `setup/setup.sh`: run the full workstation setup flow in order
- `setup/01-system-update.sh`: update package lists and upgrade installed packages
- `setup/02-core-packages.sh`: install core development packages and Bash-it
- `setup/03-flatpak.sh`: install Flatpak, add Flathub, and install Discord
- `setup/04-npm-tools.sh`: install global npm CLI tools
- `setup/05-vscode.sh`: install VS Code from the official Microsoft repository
- `setup/06-vscode-extensions.sh`: install common VS Code extensions
- `setup/07-docker.sh`: install Docker CE and enable the Docker service
- `setup/08-dev-folders.sh`: create the `~/workspace` development directory
- `setup/09-bash-aliases.sh`: append custom shell aliases to `~/.bashrc`
- `setup/10-auth-keys.sh`: import SSH and GPG keys and configure Git signing
- `setup/11-second-brain-drive-sync.sh`: sync a readable Second Brain folder to Google Drive every five minutes

Usage:

```bash
bash setup/setup.sh
```

The Second Brain step expects the vault at `~/Documents/Second-Brain`. It installs
`rclone` when needed, configures a user systemd timer, and excludes Git data,
credentials, caches, plugins, and local history. If the `gdrive` remote does not
exist, the script opens the interactive `rclone` configuration.

Run only this step with:

```bash
bash setup/11-second-brain-drive-sync.sh
```

Optional environment variables:

```bash
SECOND_BRAIN_DIR="$HOME/Documents/Second-Brain" \
SECOND_BRAIN_REMOTE="gdrive" \
SECOND_BRAIN_DRIVE_FOLDER="Second Brain" \
bash setup/11-second-brain-drive-sync.sh
```

## Docker Scripts

- `docker/main.sh`: menu to run the Docker helper scripts
- `docker/docker-verify.sh`: verify Docker CLI, daemon, socket, group membership, and `hello-world`
- `docker/docker-cleanup.sh`: clean Docker resources in `safe` or `full` mode
- `docker/dockerfile-init.sh`: generate a starter `Dockerfile` for `node`, `python`, `go`, or `java`

Usage:

```bash
bash docker/main.sh
cd docker && ./main.sh
```
