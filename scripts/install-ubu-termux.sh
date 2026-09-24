#!/usr/bin/env bash
# Provision the Ubuntu runtime used by the Termux-only `ubu` command.

set -euo pipefail

readonly DISTRO="${UBU_DISTRO:-ubuntu}"
readonly DISTRO_IMAGE="${UBU_DISTRO_IMAGE:-ubuntu:24.04}"
readonly NODE_MAJOR="${UBU_NODE_MAJOR:-24}"
readonly GUEST_PATH="${UBU_GUEST_PATH:-/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin}"
DRY_RUN=false

info() { printf '▸ %s\n' "$*"; }
ok() { printf '✔ %s\n' "$*"; }
fail() { printf '✘ %s\n' "$*" >&2; exit 1; }

is_termux() {
  [[ -n "${PREFIX:-}" && "$PREFIX" == */com.termux/files/usr ]]
}

print_command() {
  printf '  [dry-run]'
  printf ' %q' "$@"
  printf '\n'
}

run() {
  if $DRY_RUN; then
    print_command "$@"
  else
    "$@"
  fi
}

guest_run() {
  if $DRY_RUN; then
    print_command proot-distro login "$DISTRO" \
      --isolated --env "PATH=$GUEST_PATH" -- "$@"
  else
    proot-distro login "$DISTRO" \
      --isolated --env "PATH=$GUEST_PATH" -- "$@"
  fi
}

is_distro_installed() {
  command -v proot-distro >/dev/null 2>&1 &&
    proot-distro list --quiet 2>/dev/null | grep -Fxq "$DISTRO"
}

install_distro() {
  if is_distro_installed; then
    ok "Ubuntu container already installed"
    return
  fi

  info "Installing $DISTRO_IMAGE"
  run proot-distro install "$DISTRO_IMAGE"
}

install_guest_prerequisites() {
  info "Installing Ubuntu runtime prerequisites"
  guest_run env DEBIAN_FRONTEND=noninteractive apt-get update
  guest_run env DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates curl git xz-utils
}

node_is_compatible() {
  local major
  major="$(proot-distro login "$DISTRO" \
    --isolated --env "PATH=$GUEST_PATH" \
    -- node -p 'Number(process.versions.node.split(".")[0])' 2>/dev/null || true)"
  [[ "$major" =~ ^[0-9]+$ ]] && ((major >= 22))
}

install_node() {
  if ! $DRY_RUN && node_is_compatible; then
    ok "Compatible Node.js already installed"
    return
  fi

  info "Installing Node.js ${NODE_MAJOR}.x from NodeSource"
  guest_run bash -lc \
    "curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs"
}

install_pnpm() {
  if ! $DRY_RUN && proot-distro login "$DISTRO" \
    --isolated --env "PATH=$GUEST_PATH" \
    -- pnpm --version >/dev/null 2>&1; then
    ok "pnpm already installed"
    return
  fi

  info "Installing pnpm with npm"
  guest_run npm install --global pnpm@latest
}

verify_runtime() {
  if $DRY_RUN; then
    info "Runtime verification would check Node.js and pnpm versions"
    return
  fi

  local node_version pnpm_version
  node_version="$(proot-distro login "$DISTRO" \
    --isolated --env "PATH=$GUEST_PATH" -- node --version)"
  pnpm_version="$(proot-distro login "$DISTRO" \
    --isolated --env "PATH=$GUEST_PATH" -- pnpm --version)"
  ok "Ubuntu runtime ready (Node.js $node_version, pnpm $pnpm_version)"
}

main() {
  case "${1:-}" in
    --dry-run) DRY_RUN=true; shift ;;
    '') ;;
    *) fail "usage: install-ubu-termux.sh [--dry-run]" ;;
  esac
  (($# == 0)) || fail "usage: install-ubu-termux.sh [--dry-run]"

  is_termux || fail "this bootstrap is supported only in Termux"

  if ! command -v proot-distro >/dev/null 2>&1; then
    if $DRY_RUN; then
      print_command pkg install -y proot-distro
    else
      fail "proot-distro is missing; run the main dotfiles installer first"
    fi
  fi

  install_distro
  install_guest_prerequisites
  install_node
  install_pnpm
  verify_runtime
}

main "$@"
