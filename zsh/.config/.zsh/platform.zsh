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

if [[ -z ${WM_CMD:-} ]]; then
  if [[ "$PLATFORM" == termux ]]; then
    export WM_CMD=none
  else
    export WM_CMD=zellij
  fi
  export WM_CMD_IS_DEFAULT=true
else
  export WM_CMD_IS_DEFAULT=false
fi

add_path() {
  local p
  for p in "$@"; do
    [[ -d "$p" ]] && export PATH="$p:$PATH"
  done
}
