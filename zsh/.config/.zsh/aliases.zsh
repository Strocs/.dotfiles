# User-defined aliases, grouped by purpose
alias cls="clear"
alias ocode="opencode . --port 4096 --hostname 0.0.0.0"

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
  remote() { sudo -v || return 1; sudo systemctl start sshd tailscaled || return 1; tailscale ip -4; }
  remotedown() { sudo systemctl stop sshd tailscaled; }
fi
