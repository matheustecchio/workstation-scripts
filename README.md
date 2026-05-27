# workstation-scripts

Simple scripts to set up my Ubuntu/Linux Mint workstation.

## Content

- `setup/`: install packages, Docker, VS Code, aliases, and import auth keys
- `docker/`: verify Docker, clean Docker resources, generate starter Dockerfiles, and run these tools from a menu
- `merge_repo.sh`: merge another git repository into a subfolder

## Docker Scripts

- `docker/main.sh`: menu to run the Docker helper scripts
- `docker/docker-verify.sh`: verify Docker CLI, daemon, socket, group membership, and `hello-world`
- `docker/docker-cleanup.sh`: clean Docker resources in `safe` or `full` mode
- `docker/dockerfile-init.sh`: generate a starter `Dockerfile` for `node`, `python`, `go`, or `java`

Examples:

```bash
bash docker/main.sh
bash docker/main.sh verify
bash docker/main.sh cleanup safe
bash docker/main.sh init node 3000
```
