# User-defined aliases, grouped by purpose
alias cls="clear"
alias ocode="opencode . --port 4096 --hostname 0.0.0.0"
alias gs="gentle-shell"
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
alias gst="git status"
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
  remote() {
    sudo -v || return 1
    local ssh_service=$(_remote_ssh_service)
    sudo ssh-keygen -A || return 1
    sudo systemctl start "$ssh_service" tailscaled || return 1
    print "SSH service ($ssh_service): $(systemctl is-active "$ssh_service")"
    print "Tailscale service: $(systemctl is-active tailscaled)"
    if ! tailscale status --self; then
      print -u2 "Tailscale is not connected. Run 'sudo tailscale up' to authenticate this device."
      return 1
    fi
    print "SSH address: $(tailscale ip -4)"
  }
  remotedown() {
    local ssh_service=$(_remote_ssh_service)
    sudo systemctl stop "$ssh_service" tailscaled
  }
fi
