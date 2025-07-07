# User-defined aliases, grouped by purpose

# General
alias cls="clear"
alias start="explorer.exe"

# File editing
alias wt="nvim /mnt/c/Users/iganm/.wezterm.lua"
alias nv="nvim ."
alias fzfnvim='nvim $(fzf --preview="bat --theme=gruvbox-dark --color=always {}")'

# Obsidian vault
alias ov="cd /mnt/d/documents/StrocsVault/"
alias pushov="cd /mnt/d/documents/StrocsVault/ && git add . && git commit -m 'update vault' && git push origin main && cd -"
alias pullov="cd /mnt/d/documents/StrocsVault/ && git pull && cd -"

# Development
alias brd="bun run dev"
alias prd="pnpm run dev"
alias nrd="npm run dev"
alias py="python3"
alias lua="luajit"
alias buildwin="GOOS=windows GOARCH=amd64 go build -o testapp.exe && cp testapp.exe /mnt/d/Documents/Dev/"

# Git
alias gs="git status"
alias gb="git branch"
alias gco="git checkout"
alias gpl="git pull"
alias gcl="git clone"
alias gm="git merge"

# Build GO App on windows

gobwin() {
  if [ -z "$1" ]; then
    echo "Error: Please provide a module name (e.g., gobwin myapp)"
    return 1
  fi
  local module_name="$1"
  CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ GOOS=windows GOARCH=amd64 go build -tags glfw -o "${module_name}.exe" && cp "${module_name}.exe" /mnt/d/Documents/Dev/executables
}

