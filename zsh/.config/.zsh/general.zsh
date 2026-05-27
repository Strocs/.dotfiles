# General shell settings and Oh My Zsh configuration

# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# XDG_RUNTIME_DIR setup (only create if it doesn’t exist)
if [ -z "$IS_TERMUX" ]; then 
  if [ ! -d "/tmp/${USER}-runtime" ]; then
    mkdir -p "/tmp/${USER}-runtime" && chmod -R 0700 "/tmp/${USER}-runtime"
  fi
  export XDG_RUNTIME_DIR="/tmp/${USER}-runtime"
fi

# Editor
export EDITOR='nvim'

