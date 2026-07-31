# User-defined aliases, grouped by purpose

# General
alias cls="clear"
alias start="explorer.exe"
alias fxnet="$HOME/.dotfiles/scripts/disable-lso-ipv4.sh" # Disable ipv4 of vEthernet for improve connections
alias ocode="opencode . --port 4096 --hostname 0.0.0.0"

# File editing
alias tconf=$([ -z $IS_TERMUX ] && echo "nvim /mnt/c/Users/iganm/.wezterm.lua" || echo "nvim $HOME/.termux/termux.properties")
alias nv="nvim"
alias fzfnvim='nvim $(fzf --preview="bat --theme=gruvbox-dark --color=always {}")'

# Obsidian vault

alias ov="cd $OBSIDIAN_VAULT_PATH"
alias pushov="OV_TMP_PATH=$PWD && ov && git add . && git commit -m 'update vault' && git push && cd $OV_TMP_PATH"
alias pullov="OV_TMP_PATH=$PWD && ov && git pull && cd $OV_TMP_PATH"

# Development
alias brd="bun run dev"
alias prd="pnpm run dev"
alias nrd="npm run dev"
alias py="python3"
alias lua="luajit"

# Git
alias lg="lazygit"
alias gs="git status"
alias gb="git branch"
alias gco="git checkout"
alias gpl="git pull"
alias gcl="git clone"
alias gm="git merge"
alias gp="git push"


# Build GO App on windows
gowin() {
  local output="${@[-1]}"
  local args="${@:1:-1}"
  GOOS=windows GOARCH=amd64 go build $args -o "${output}.exe"
}

remote() {
  sudo -v || return 1

  if systemctl is-active --quiet sshd; then
    echo "sshd ya estaba activo"
  else
    sudo systemctl start sshd || return 1
    echo "sshd iniciado"
  fi

  if systemctl is-active --quiet tailscaled; then
    echo "tailscaled ya estaba activo"
  else
    sudo systemctl start tailscaled || return 1
    echo "tailscaled iniciado"
  fi

  local ip=""
  local dns=""
  local attempts=0

  echo "Esperando conexión de Tailscale..."

  while (( attempts < 15 )); do
    ip=$(tailscale ip -4 2>/dev/null | head -n1)

    if [[ -n "$ip" ]]; then
      break
    fi

    sleep 1
    (( attempts++ ))
  done

  if [[ -z "$ip" ]]; then
    echo "Error: Tailscale no obtuvo una IP."
    echo "Estado actual:"
    tailscale status
    return 1
  fi

  # El segundo campo de la línea propia es el nombre MagicDNS corto.
  dns=$(tailscale status --self 2>/dev/null | awk 'NR == 1 { print $2 }')

  echo
  echo "Acceso remoto disponible:"
  echo "  IP Tailscale: $ip"
  echo "  MagicDNS:     $dns"
  echo
  echo "Conexiones SSH:"
  echo "  ssh strocs@$ip"

  if [[ -n "$dns" ]]; then
    echo "  ssh strocs@$dns"
  fi
}

remotedown() {
  sudo -v || return 1

  if systemctl is-active --quiet sshd; then
    sudo systemctl stop sshd
    echo "sshd detenido"
  else
    echo "sshd ya estaba detenido"
  fi

  if systemctl is-active --quiet tailscaled; then
    sudo systemctl stop tailscaled
    echo "tailscaled detenido"
  else
    echo "tailscaled ya estaba detenido"
  fi
}
