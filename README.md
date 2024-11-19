# .Strocs

dotfiles and custom plugins configs

```bash
# install stow and git
sudo apt-get install stow git

# clone this repo
git clone $thisrepo

cd .dotfiles && stow .
``` 

## Homebrew
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

## ZSH
`sudo apt-get install zsh`

#### Oh-my-zsh

Install oh-my-zsh:
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
> Not overrides current .zshrc

#### Install zsh plugins

- zsh-autosuggestion
    `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`

- zsh-syntax-highlighting
    `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`

Add to .zshrc:
```shell
plugins=(
    # other plugins...
    zsh-syntax-highlighting
    zsh-autosuggestion
)
```

#### Carapace (autocompletion)
`brew install carapace`

#### Zoxide (smart cd)
`brew install zoxide`

#### Atuin (shell history)
`brew install atuin`
