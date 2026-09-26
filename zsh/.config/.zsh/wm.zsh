# Window manager configuration.
# WM_CMD is chosen per platform in platform.zsh:
#   zellij (desktop default), tmux, herdr, or none (Termux default).
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
    "herdr")
      WM_VAR="/$HERDR"
      ;;
    *)
      echo "Unknown WM_CMD: $WM_CMD. Supported: tmux, zellij, herdr, none" >&2
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
  # For herdr, check HERDR_ENV (set by herdr in pane env) to prevent nested launch
  # Herdr itself blocks if HERDR_ENV=1 (see src/main.rs:should_block_nested)
  local already_running=0
  if [[ "$WM_CMD" == "herdr" ]]; then
    # HERDR_ENV=1 is set by herdr in every pane it manages.
    # If present, we are already inside a herdr session → don't re-exec.
    [[ -n "${HERDR_ENV:-}" ]] && already_running=1
  else
    # For tmux/zellij: empty WM_VAR (after removing leading /) means not running
    [[ -z "${WM_VAR#/}" ]] && already_running=0 || already_running=1
  fi

  if [[ $- == *i* ]] && [[ $already_running -eq 0 ]] && [[ -t 1 ]]; then
    exec "$WM_CMD"
  fi
}

# Start the window manager if needed
start_if_needed
