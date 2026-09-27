# Platform and distribution detection.
# Supported: Termux, Ubuntu and Arch (native or WSL).

if [[ -d /data/data/com.termux && -n ${PREFIX:-} ]]; then
  export PLATFORM=termux
  export DISTRO=termux
else
  DISTRO_ID=""
  [[ -r /etc/os-release ]] && . /etc/os-release
  case "${ID:-}" in
    ubuntu) export PLATFORM=ubuntu; export DISTRO=ubuntu ;;
    arch) export PLATFORM=arch; export DISTRO=arch ;;
    *) export PLATFORM=unsupported; export DISTRO="${ID:-unknown}" ;;
  esac
fi

export IS_TERMUX=$([[ "$PLATFORM" == termux ]] && echo true || echo false)
export IS_DESKTOP=$([[ "$PLATFORM" != termux ]] && echo true || echo false)
export IS_WSL=$([[ -r /proc/version ]] && grep -qi microsoft /proc/version && echo true || echo false)

# Recover WSL interop socket when missing in detached multiplexer panes (e.g. herdr/tmux)
if [[ "$IS_WSL" == true && -z "$WSL_INTEROP" ]]; then
  export WSL_INTEROP=$(ls -t /run/WSL/*_interop 2>/dev/null | head -n1)
fi

if [[ -z ${WM_CMD:-} ]]; then
  if [[ "$PLATFORM" == termux ]]; then
    export WM_CMD=none
  else
    export WM_CMD=herdr
  fi
  export WM_CMD_IS_DEFAULT=true
else
  export WM_CMD_IS_DEFAULT=false
fi

# Validate WM_CMD value
case "$WM_CMD" in
  zellij|tmux|herdr|none) ;;
  *)
    echo "WM_CMD='$WM_CMD' no soportado. Usando zellij." >&2
    export WM_CMD=zellij
    export WM_CMD_IS_DEFAULT=true
    ;;
esac

add_path() {
  local p
  for p in "$@"; do
    [[ -d "$p" ]] && export PATH="$p:$PATH"
  done
}
