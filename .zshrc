# Main entry point for Zsh configuration

ZSH_CONFIG_DIR="$HOME/.config/.zsh"

# Source all .zsh files in the config directory
if [ -d "$ZSH_CONFIG_DIR" ]; then
  for config_file in "$ZSH_CONFIG_DIR"/*.zsh; do
    [ -r "$config_file" ] && source "$config_file"
  done
fi

