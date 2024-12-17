# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Create folder and env for XDG_RUNTIME_DIR
mkdir -p /tmp/${USER}-runtime && chmod -R 0700 /tmp/${USER}-runtime
export XDG_RUNTIME_DIR=/tmp/${USER}-runtime

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	command-not-found
  zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='nvim'

# Aliases
alias wt="nvim /mnt/c/Users/iganm/.wezterm.lua"
alias start="explorer.exe"
## obsidian
alias ov="cd /mnt/d/documents/StrocsVault/"
alias pushov="export current_path=${0:a:h} && ov && git add . && git commit -m 'update vault' && git push origin main && cd $current_path"
alias pullov="export current_path=${0:a:h} && ov && git pull && cd $current_path"
## dev
alias brd="bun run dev"
alias prd="pnpm run dev"
alias nrd="npm run dev"
alias py="python3"
## git
alias gs="git status"
alias gco="git checkout"
alias gpl="git pull"
alias gcl="git clone"
alias gm="git merge"

## fzf for nvim ??
alias fzfnvim='nvim $(fzf --preview="bat --theme=gruvbox-dark --color=always {}")'

# Support for Windows commands
export PATH="$PATH:/mnt/c/Windows/"

# BREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Carapace config (autocomplete)
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# Atuin (shell history)
eval "$(atuin init zsh)"

# TMUX
WM_VAR="/$TMUX"

if [[ $- == *i* ]] && [[ -z "${WM_VAR#/}" ]] && [[ -t 1 ]]; then
	exec tmux
fi

# NodeJs
export PATH="/home/linuxbrew/.linuxbrew/opt/node@22/bin:$PATH"

# WSL
export PATH="/usr/lib/wsl/lib:$PATH"
