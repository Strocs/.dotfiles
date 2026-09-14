# Environment variable and PATH modifications

# Detect Termux/Android
if [ -d "/data/data/com.termux" ] && [ -n "$PREFIX" ]; then
   export IS_TERMUX=true
fi

# Define individual paths
GO_PATH="$HOME/go/bin"

# Define obsidian vault path for non-mobile and mobile
export OBSIDIAN_VAULT_PATH=$([ -z "$IS_TERMUX" ] && echo "/mnt/d/documents/StrocsVault/" || echo "$HOME/storage/documents/obsidian-vault")

# Desktop Linux/WSL-specific configuration (non-mobile)
if [ -z "$IS_TERMUX" ]; then

  WINDOWS_PATH="/mnt/c/Windows"                   # Windows system commands
  WIN_SYSTEM32="/mnt/c/Windows/System32"           # Required for rundll32.exe (xdg-open, etc.)
  WIN_POWERSHELL="/mnt/c/Windows/System32/WindowsPowerShell/v1.0"  # Required for opencode clipboard
  WSL_LIB_PATH="/usr/lib/wsl/lib"                 # WSL-specific libraries
  LOCAL_BIN_PATH="/home/strocs/.local/bin"
  # Consolidate into PATH
  export PATH="$GO_PATH:$WINDOWS_PATH:$WIN_SYSTEM32:$WIN_POWERSHELL:$WSL_LIB_PATH:$LOCAL_BIN_PATH:$PATH"

  # PKG_CONFIG_PATH for development libraries
  PKG_CONFIG_PATH_BASE="/usr/lib/x86_64-linux-gnu/pkgconfig"

  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH_BASE:$PKG_CONFIG_PATH"
fi

# bun completions (Termux-aware)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# pnpm (Termux-aware)
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# Turso
export PATH="$PATH:$HOME/.turso"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# Brew (Desktop only — not available in Termux)
if [[ -z "$IS_TERMUX" ]] && [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Gentle AI switch — va después de brew para ganar precedencia
export GENTLE_PATH="$HOME/.local/bin/gentle-ai/gentle-ai"
export PATH="$GENTLE_PATH:$PATH"
