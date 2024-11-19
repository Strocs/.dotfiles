# .Strocs

dotfiles and custom plugins configs

To create this folder I used Stow

```bash
# install stow and git
sudo apt-get install stow git

# clone this repo
git clone $thisrepo

cd .dotfiles && stow .
``` 

## ZSH
`sudo apt-get install zsh`

#### for Oh-my-zsh

Install oh-my-zsh:
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

> Not overrides current .zshrc


