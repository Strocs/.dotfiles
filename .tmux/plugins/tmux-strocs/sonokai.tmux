#!/usr/bin/env bash

# source and run sonokai theme

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR=$current_dir
tmux set-environment -g "@sonokai-root" "$ROOT_DIR"

$current_dir/scripts/sonokai.sh
