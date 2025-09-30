# .Strocs

## Pre Install 
Ubuntu:
`sudo apt-get install build-essential procps curl file git`

Termux:
`pkg install build-essential procps curl file git`


## Homebrew (only on PC)
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

## ZSH
```
brew install zsh
command -v zsh | sudo tee -a /etc/shells
chsh -s ${which zsh}
```


#### Oh-my-zsh

Install oh-my-zsh:
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

#### Install zsh plugins

- zsh-autosuggestion
    `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`

- zsh-syntax-highlighting
    `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`

- zsh-ai 
   `git clone https://github.com/matheusml/zsh-ai ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-ai` 


## TMUX

Install tmux if don't have it:
``` 
which tmux
# if not found
sudo apt-get install tmux
```

#### Plugins
`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

Then `C-Space + I` to install plugins.

## Tools
Ubuntu:
`brew install stow carapace zoxide atuin lazygit neovim fzf ripgrep fd`

Termux:
`pkg install stow carapace zoxide atuin neovim fzf ripgrep fd`


- Carapace (autocompletion)
- Zoxide (smart cd)
- Atuin (shell history)


## Languages Tools

#### Go
`brew install go`

#### Javascript / Typescript
`brew install node@22 oven-sh/bun/bun`

####  Java
`brew install gradle`

