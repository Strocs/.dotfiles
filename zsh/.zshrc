# Main entry point for Zsh configuration
ZSH_CONFIG_DIR="$HOME/.config/.zsh"

[ -r "$ZSH_CONFIG_DIR/platform.zsh" ] && source "$ZSH_CONFIG_DIR/platform.zsh"
[ "$PLATFORM" = unsupported ] && print -u2 "Unsupported platform/distro: $DISTRO"
[ -r "$ZSH_CONFIG_DIR/paths.zsh" ] && source "$ZSH_CONFIG_DIR/paths.zsh"
[ -r "$ZSH_CONFIG_DIR/general.zsh" ] && source "$ZSH_CONFIG_DIR/general.zsh"
[ -r "$ZSH_CONFIG_DIR/plugins.zsh" ] && source "$ZSH_CONFIG_DIR/plugins.zsh"
[ -r "$ZSH_CONFIG_DIR/aliases.zsh" ] && source "$ZSH_CONFIG_DIR/aliases.zsh"

[[ -r "$HOME/.config/zellij/hooks/tab-names.zsh" && -n $commands[zsh] && -n $commands[zellij] ]] && source "$HOME/.config/zellij/hooks/tab-names.zsh"
[ -r "$ZSH_CONFIG_DIR/wm.zsh" ] && source "$ZSH_CONFIG_DIR/wm.zsh"

typeset -U PATH
alias xclean="/bin/bash $HOME/xclean.sh"
