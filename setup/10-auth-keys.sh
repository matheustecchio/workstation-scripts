#!/usr/bin/env bash
# Imports existing SSH and GPG keys from a previous machine and configures Git signing.

# =========================================================
# IMPORT EXISTING SSH + GPG KEYS + GIT CONFIG
# Linux Mint / Ubuntu
# =========================================================

set -e

echo "================================================="
echo " Installing required packages"
echo "================================================="

sudo apt update

sudo apt install -y \
    gnupg \
    pinentry-gnome3 \
    seahorse \
    openssh-client \
    xclip

echo "================================================="
echo " Git identity"
echo "================================================="

read -p "Git username: " GIT_NAME
read -p "Git email: " GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

echo "================================================="
echo " SSH KEY IMPORT"
echo "================================================="
echo ""
echo "Copy these files from your old PC:"
echo ""
echo "  ~/.ssh/id_ed25519"
echo "  ~/.ssh/id_ed25519.pub"
echo ""
echo "Put them somewhere accessible."
echo ""

read -p "Press ENTER after copying SSH keys..."

mkdir -p ~/.ssh

read -p "Path to private SSH key: " SSH_PRIVATE
read -p "Path to public SSH key: " SSH_PUBLIC

cp "$SSH_PRIVATE" ~/.ssh/id_ed25519
cp "$SSH_PUBLIC" ~/.ssh/id_ed25519.pub

chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

echo "================================================="
echo " Starting SSH agent"
echo "================================================="

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_ed25519

echo "================================================="
echo " Testing GitHub SSH"
echo "================================================="

echo ""
echo "Run this after script finishes:"
echo ""
echo "ssh -T git@github.com"
echo ""

echo "================================================="
echo " GPG KEY IMPORT"
echo "================================================="
echo ""
echo "Copy these files from old PC:"
echo ""
echo "  private-gpg-key.asc"
echo "  public-gpg-key.asc"
echo ""

read -p "Press ENTER after copying GPG key files..."

read -p "Path to private GPG key: " GPG_PRIVATE
read -p "Path to public GPG key: " GPG_PUBLIC

gpg --import "$GPG_PRIVATE"
gpg --import "$GPG_PUBLIC"

echo "================================================="
echo " Listing imported GPG keys"
echo "================================================="

gpg --list-secret-keys --keyid-format=long

echo ""
echo "Find line like:"
echo "sec   rsa4096/ABCD1234EFGH5678"
echo ""

read -p "Paste your GPG KEY ID: " GPG_KEY_ID

echo "================================================="
echo " Trusting GPG key"
echo "================================================="

cat << EOF | gpg --command-fd 0 --edit-key "$GPG_KEY_ID"
trust
5
y
quit
EOF

echo "================================================="
echo " Configuring Git signing"
echo "================================================="

git config --global user.signingkey "$GPG_KEY_ID"

git config --global commit.gpgsign true

git config --global gpg.program gpg

echo "================================================="
echo " SSH CONFIG"
echo "================================================="

cat << EOF >> ~/.ssh/config

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519

EOF

chmod 600 ~/.ssh/config

echo "================================================="
echo " Finished"
echo "================================================="

echo ""
echo "You are now reusing your OLD:"
echo "- SSH identity"
echo "- GPG identity"
echo "- GitHub trust"
echo "- Verified commit signature"
echo ""
echo "No new keys were created."
echo ""

echo "Test commands:"
echo ""
echo "ssh -T git@github.com"
echo ""
echo "git commit -S -m 'test'"
