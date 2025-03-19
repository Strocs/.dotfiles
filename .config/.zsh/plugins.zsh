# Plugin configurations and initialization

# Oh My Zsh plugins
plugins=(
  command-not-found
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# Atuin (shell history)
eval "$(atuin init zsh)"

# Carapace (autocomplete)
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)
