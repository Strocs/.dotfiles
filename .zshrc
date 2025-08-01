# Main entry point for Zsh configuration

ZSH_CONFIG_DIR="$HOME/.config/.zsh"

# Source configuration files in a specific, logical order to prevent race conditions.

# 1. Set all environment variables and paths first so the shell can find commands.
[ -r "$ZSH_CONFIG_DIR/paths.zsh" ] && source "$ZSH_CONFIG_DIR/paths.zsh"

# 2. Load general settings and the main framework (Oh My Zsh).
#    This will initialize the completion system.
[ -r "$ZSH_CONFIG_DIR/general.zsh" ] && source "$ZSH_CONFIG_DIR/general.zsh"

# 3. Load plugins that depend on the framework and correct PATH.
#    Carapace will now correctly hook into the completion system.
[ -r "$ZSH_CONFIG_DIR/plugins.zsh" ] && source "$ZSH_CONFIG_DIR/plugins.zsh"

# 4. Load aliases.
[ -r "$ZSH_CONFIG_DIR/aliases.zsh" ] && source "$ZSH_CONFIG_DIR/aliases.zsh"

# 5. Execute the window manager as the final step.
#    The 'exec' command replaces the shell process, so it must be last.
[ -r "$ZSH_CONFIG_DIR/wm.zsh" ] && source "$ZSH_CONFIG_DIR/wm.zsh"


