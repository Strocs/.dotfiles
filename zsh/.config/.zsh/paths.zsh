# Environment variable and PATH modifications.
# Platform detection lives in platform.zsh (loaded first).

export OBSIDIAN_VAULT_PATH=$([[ "$PLATFORM" == termux ]] && echo "$HOME/storage/documents/obsidian-vault" || echo "/mnt/d/documents/StrocsVault/")

if [[ "$IS_DESKTOP" == true ]]; then
  add_path "$HOME/go/bin" "$HOME/.local/bin" "$HOME/.opencode/bin"
  add_path "$HOME/.local/share/pnpm/bin" "$HOME/.turso"
  [[ "$IS_WSL" == true ]] && add_path "/mnt/c/Windows" "/mnt/c/Windows/System32" "/usr/lib/wsl/lib"
  [[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
  [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  add_path "$HOME/.local/bin"
fi

export PNPM_HOME="$HOME/.local/share/pnpm"
add_path "$PNPM_HOME/bin"

# Pi agent configuration is managed in dotfiles and exposed through ~/.pi/agent symlinks.
export PI_CODING_AGENT_DIR="$HOME/.dotfiles/pi-agent/.pi/agent"
export GENTLE_PI_COMMANDS_KEY="ctrl+shift+k"

export PATH="$HOME/.opencode/bin:$PATH"
