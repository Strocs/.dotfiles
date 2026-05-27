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
  WSL_LIB_PATH="/usr/lib/wsl/lib"                 # WSL-specific libraries
  LOCAL_BIN_PATH="/home/strocs/.local/bin"
  # Consolidate into PATH
  export PATH="$GO_PATH:$WINDOWS_PATH:$WSL_LIB_PATH:$LOCAL_BIN_PATH:$PATH"

  # PKG_CONFIG_PATH for development libraries
  PKG_CONFIG_PATH_BASE="/usr/lib/x86_64-linux-gnu/pkgconfig"

  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH_BASE:$PKG_CONFIG_PATH"
fi

# bun completions
[ -s "/home/strocs/.bun/_bun" ] && source "/home/strocs/.bun/_bun"

# pnpm
export PNPM_HOME="/home/strocs/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Turso
export PATH="$PATH:/home/strocs/.turso"

