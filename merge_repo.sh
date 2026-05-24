#!/usr/bin/env bash

# Merges another repository into the current one as a subfolder.

read -r -p "Repository Name: " repo_name
read -r -p "Repository HTTPS or SSH: " repo_link

git remote add "$repo_name" "$repo_link"
git fetch "$repo_name"
git merge "$repo_name/main" --allow-unrelated-histories
read -p "Press enter to continue"
git add .
mkdir "$repo_name"
git ls-tree -z --name-only "$repo_name/main" | xargs -0 -I {} git mv {} "$repo_name/"
git commit -m "Move $repo_name into subfolder"
