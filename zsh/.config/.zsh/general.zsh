# General shell settings and Oh My Zsh configuration

# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# XDG_RUNTIME_DIR setup (only create if it doesn’t exist)
if [ "$IS_DESKTOP" = true ]; then
  if [ ! -d "/tmp/${USER}-runtime" ]; then
    mkdir -p "/tmp/${USER}-runtime" && chmod -R 0700 "/tmp/${USER}-runtime"
  fi
  export XDG_RUNTIME_DIR="/tmp/${USER}-runtime"
fi

# Editor
export EDITOR='nvim'

# WSL screenshot clipboard daemon
if [[ "$IS_WSL" == true && -n "$WSL_INTEROP" ]] && command -v wsl-screenshot-cli >/dev/null 2>&1; then
  if ! pgrep -f "wsl-screenshot-cli.*start" >/dev/null 2>&1; then
    wsl-screenshot-cli start --daemon --quiet 2>/dev/null
  fi
fi

