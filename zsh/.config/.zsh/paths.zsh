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
export GENTLE_PI_COMMANDS_KEY="ctrl+shift+k"
export GENTLE_PI_AGENTS_PI="gentle-shell"

# Pin the pi runtime that gentle-shell launches.
# gentle-shell resolves pi in this order: GENTLE_SHELL_PI, then the optional peer
# pnpm auto-installs next to gentle-pi, then `pi` on PATH. The peer wins over PATH
# and `pi update` cannot reach it: pnpm resolves it into gentle-pi's own store
# instance, so a global pi upgrade lands in a different directory and the TUI keeps
# running the old version (and keeps advertising the update it already has). Pointing
# at the pnpm shim keeps this stable across `pi update`, since the shim path is fixed
# and only its target changes. Guarded so a missing pnpm install falls back to
# gentle-shell's own resolution instead of pointing it at a nonexistent binary.
[[ -x "$PNPM_HOME/bin/pi" ]] && export GENTLE_SHELL_PI="$PNPM_HOME/bin/pi"

export PATH="$HOME/.opencode/bin:$PATH"
