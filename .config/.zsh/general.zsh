# General shell settings and Oh My Zsh configuration

# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# XDG_RUNTIME_DIR setup (only create if it doesn’t exist)
if [ ! -d "/tmp/${USER}-runtime" ]; then
  mkdir -p "/tmp/${USER}-runtime" && chmod -R 0700 "/tmp/${USER}-runtime"
fi
export XDG_RUNTIME_DIR="/tmp/${USER}-runtime"

# Editor
export EDITOR='nvim'

# Uncomment to enable options as needed (FOR WHAT?)
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"
