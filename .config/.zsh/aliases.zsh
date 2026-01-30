# User-defined aliases, grouped by purpose

# General
alias cls="clear"
alias start="explorer.exe"
alias dipv4="$HOME/.dotfiles/scripts/disable-lso-ipv4.sh" # Disable ipv4 of vEthernet for improve connections
alias oc="opencode"

# File editing
alias tconf=$([ -z $IS_TERMUX ] && echo "nvim /mnt/c/Users/iganm/.wezterm.lua" || echo "nvim $HOME/.termux/termux.properties")
alias nv="nvim"
alias pnvim="NVIM_APPNAME='plainvim' nvim"
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

