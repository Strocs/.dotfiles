# Window manager configuration

# Configurable window manager settings
WM_CMD="tmux"          # Options: "tmux" or "zellij"

# Function to start the window manager if conditions are met
start_if_needed() {
  # Set WM_VAR based on WM_CMD
  case "$WM_CMD" in
    "tmux")
      WM_VAR="/$TMUX"
      ;;
    "zellij")
      WM_VAR="/$ZELLIJ"
      ;;
    *)
      echo "Unknown WM_CMD: $WM_CMD. Supported: tmux, zellij" >&2
      return 1
      ;;
  esac

  # Check if WM_CMD is installed
  if ! command -v "$WM_CMD" >/dev/null 2>&1; then
    echo "$WM_CMD not installed" >&2
    return 1
  fi

  # Start WM if interactive, not already running, and stdout is a terminal
  if [[ $- == *i* ]] && [[ -z "${WM_VAR#/}" ]] && [[ -t 1 ]]; then
    exec "$WM_CMD"
  fi
}

# Start the window manager if needed
start_if_needed
