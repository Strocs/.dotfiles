# Environment variable and PATH modifications

# Define individual paths
GO_PATH="$HOME/go/bin"                          # Go binaries
WINDOWS_PATH="/mnt/c/Windows"                   # Windows system commands
WSL_LIB_PATH="/usr/lib/wsl/lib"                 # WSL-specific libraries
NODE_PATH="/home/linuxbrew/.linuxbrew/opt/node@22/bin"  # Node.js via Homebrew
BREW_PATH="/home/linuxbrew/.linuxbrew/bin"      # Homebrew binaries

# Consolidate into PATH
export PATH="$GO_PATH:$WINDOWS_PATH:$WSL_LIB_PATH:$NODE_PATH:$BREW_PATH:$PATH"

# Brew shell environment (adds more paths dynamically)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# PKG_CONFIG_PATH
PKG_CONFIG_PATH_BASE="/usr/lib/x86_64-linux-gnu/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH_BASE:$PKG_CONFIG_PATH"
