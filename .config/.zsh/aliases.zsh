# User-defined aliases, grouped by purpose

# General
alias cls="clear"
alias start="explorer.exe"
alias dipv4='/home/strocsdev/.dotfiles/scripts/disable-lso-ipv4.sh' # Disable ipv4 of vEthernet for improve connections
alias oc="opencode"

# File editing
alias tconfig=$([ -z $IS_TERMUX ] && echo "/mnt/c/Users/iganm/.wezterm.lua" || echo "$HOME/.termux/termux.properties")
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
#
gobwin() {
  if [ -z "$1" ]; then
    echo "Error: Please provide a module name (e.g., gobwin myapp)"
    return 1
  fi
  local module_name="$1"
  CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ GOOS=windows GOARCH=amd64 go build -tags glfw -o "${module_name}.exe" && cp "${module_name}.exe" /mnt/d/Documents/Dev/executables
}

