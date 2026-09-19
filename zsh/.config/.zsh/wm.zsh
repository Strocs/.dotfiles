# Window manager configuration.
# WM_CMD is chosen per platform in platform.zsh:
#   zellij (desktop default), tmux, or none (Termux default).
# Override from the environment, e.g. WM_CMD=tmux zsh

# Skip window manager entirely if disabled
if [[ "$WM_CMD" == "none" ]]; then
  return 0
fi

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
      echo "Unknown WM_CMD: $WM_CMD. Supported: tmux, zellij, none" >&2
      return 1
      ;;
  esac

  # Check if WM_CMD is installed
  if ! command -v "$WM_CMD" >/dev/null 2>&1; then
    # Only warn when the user explicitly requested a window manager
    [[ "$WM_CMD_IS_DEFAULT" != "true" ]] && echo "$WM_CMD not installed" >&2
    return 1
  fi

  # Start WM if interactive, not already running, and stdout is a terminal
  if [[ $- == *i* ]] && [[ -z "${WM_VAR#/}" ]] && [[ -t 1 ]]; then
    exec "$WM_CMD"
  fi
}

# Start the window manager if needed
start_if_needed
