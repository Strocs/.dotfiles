# User-defined aliases, grouped by purpose
alias cls="clear"
alias ocode="opencode . --port 4096 --hostname 0.0.0.0"
alias g="gentle-shell"
alias dotinstall='bash "$HOME/.dotfiles/scripts/install.sh"'

case "$PLATFORM" in
  termux) alias tconf="nvim $HOME/.termux/termux.properties" ;;
  *) alias tconf="nvim $HOME/.wezterm.lua" ;;
esac
[[ "$IS_WSL" == true ]] && alias start="explorer.exe"

alias nv="nvim"
alias fzfnvim='nvim $(fzf --preview="bat --theme=gruvbox-dark --color=always {}")'
alias ov="cd $OBSIDIAN_VAULT_PATH"
alias pushov="OV_TMP_PATH=$PWD && ov && git add . && git commit -m 'update vault' && git push && cd $OV_TMP_PATH"
alias pullov="OV_TMP_PATH=$PWD && ov && git pull && cd $OV_TMP_PATH"
alias brd="bun run dev"
alias prd="pnpm run dev"
alias nrd="npm run dev"
alias py="python3"
alias lua="luajit"
alias lg="lazygit"
alias gs="git status"
alias gb="git branch"
alias gco="git checkout"
alias gpl="git pull"
alias gcl="git clone"
alias gm="git merge"
alias gp="git push"
alias sshpc="ssh strocs@strocs"

if [[ "$IS_DESKTOP" == true ]]; then
  gowin() { local output="${@[-1]}"; local args="${@:1:-1}"; GOOS=windows GOARCH=amd64 go build $args -o "${output}.exe"; }
  _remote_ssh_service() {
    if systemctl cat sshd.service >/dev/null 2>&1; then
      print -r -- sshd
    else
      print -r -- ssh
    fi
  }
  _remote_wait_tailscale_ready() {
    local -F timeout=${1:-${REMOTE_READY_TIMEOUT:-30}}
    local -F interval=${2:-${REMOTE_READY_INTERVAL:-0.25}}
    local -F elapsed=0
    local state
    while (( elapsed <= timeout )); do
      state=$(sudo tailscale status --json 2>/dev/null | jq -r '.BackendState // empty' 2>/dev/null) || true
      case "$state" in
        Running) return 0 ;;
        NeedsLogin|Stopped) return 2 ;;
      esac
      sleep "$interval"
      elapsed=$(( elapsed + interval ))
    done
    return 1
  }
  _remote_wait_service_active() {
    local service=$1
    local -F timeout=${2:-${REMOTE_SSH_TIMEOUT:-30}}
    local -F interval=${3:-${REMOTE_SSH_INTERVAL:-0.25}}
    local -F elapsed=0
    while (( elapsed <= timeout )); do
      [[ "$(systemctl is-active "$service" 2>/dev/null)" == active ]] && return 0
      sleep "$interval"
      elapsed=$(( elapsed + interval ))
    done
    return 1
  }
  # Collie runs `tailscale serve` as your user, so without operator mode it cannot
  # publish the front door and the phone never reaches the bridge. Idempotent, and
  # it repairs itself after a stray `tailscale up` clears the operator.
  _remote_tailscale_operator() {
    local prefs
    prefs=$(tailscale debug prefs 2>/dev/null)
    if [[ -n "$prefs" ]] && ! print -r -- "$prefs" | grep -q '"OperatorUser": ""'; then
      return 0
    fi
    print "Tailscale operator: granting $USER"
    sudo tailscale set --operator="$USER" || return 1
  }
  _remote_collie_port() {
    local port
    port=$(collie status --plain 2>/dev/null | sed -n 's|.*127\.0\.0\.1:\([0-9]\{1,\}\).*|\1|p' | head -n 1)
    print -r -- "${port:-8787}"
  }
  remote() {
    sudo -v || return 1
    local ssh_service=$(_remote_ssh_service)
    sudo ssh-keygen -A || return 1
    sudo systemctl start "$ssh_service" tailscaled || return 1
    if ! _remote_wait_service_active "$ssh_service"; then
      print -u2 "SSH service ($ssh_service) did not become active in time."
      return 1
    fi
    print "SSH service ($ssh_service): active"
    print "Tailscale service: $(systemctl is-active tailscaled)"
    # No `tailscale up` here on purpose: the login is interactive and blocking, and
    # it also wipes the operator set below. Authenticate once by hand, then re-run.
    local readiness_rc=0
    _remote_wait_tailscale_ready || readiness_rc=$?
    if (( readiness_rc == 2 )); then
      print -u2 "Tailscale needs login or is stopped. Run 'sudo tailscale up' to authenticate or reconnect this device, then re-run remote."
      return 1
    elif (( readiness_rc != 0 )); then
      print -u2 "Tailscale did not become ready before the timeout."
      return 1
    fi
    _remote_tailscale_operator || return 1
    if ! tailscale status --self >/dev/null 2>&1; then
      print -u2 "Tailscale is not connected."
      return 1
    fi
    print "Tailscale: $(tailscale status --self | head -n 1)"
    print "SSH address: $(tailscale ip -4) (alias: sshpc)"
    if ! command -v collie >/dev/null 2>&1; then
      print -u2 "Collie is not on PATH. Install it with: curl -fsSL https://colliepwa.dev/install.sh | sh"
      return 1
    fi
    local port
    port=$(_remote_collie_port)
    if curl -fsS -o /dev/null --max-time 3 "http://127.0.0.1:$port/" 2>/dev/null; then
      print "Collie: already up on :$port, republishing the tailnet ingress"
      collie serve || return 1
    else
      collie start || return 1
    fi
    print "Collie URL: $(collie url 2>/dev/null)"
  }
  remotedown() {
    local ssh_service=$(_remote_ssh_service)
    if command -v collie >/dev/null 2>&1; then
      collie stop
    fi
    sudo systemctl stop "$ssh_service" tailscaled
  }
fi
