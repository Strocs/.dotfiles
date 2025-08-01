# Plugin configurations and initialization

# Oh My Zsh plugins
plugins=(
  command-not-found
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Source Oh My Zsh at the end to ensure all plugins are loaded
source "$ZSH/oh-my-zsh.sh"

# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# Atuin (shell history)
eval "$(atuin init zsh)"

# Carapace (autocomplete)
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# zsh-ai (AI assistant)
# Instruction to add a provider to zsh-ai:
#    Change the .zsh_secrets.example to .zsh_secrets and add your api key of the choosen provider
#	ANTHROPIC_API_KEY=
#	GEMINI_API_KEY=
# 	OPENAI_API_KEY=

# Load api key
[[ -f ~/.config/.zsh/.zsh_secrets ]] && source ~/.config/.zsh/.zsh_secrets

# Choose AI provider: "anthropic" (default), "gemini", "openai", or "ollama"
export ZSH_AI_PROVIDER="gemini"

# Anthropic-specific settings
# export ZSH_AI_ANTHROPIC_MODEL="claude-3-5-sonnet-20241022"  # (default)

# Gemini-specific settings
export ZSH_AI_GEMINI_MODEL="gemini-2.5-flash"  # (default)

# OpenAI-specific settings
# export ZSH_AI_OPENAI_MODEL="gpt-4o"  # (default)

# Ollama-specific settings
# export ZSH_AI_OLLAMA_MODEL="llama3.2"  # (default)
# export ZSH_AI_OLLAMA_URL="http://localhost:11434"  # (default)

source $(brew --prefix)/share/zsh-ai/zsh-ai.plugin.zsh
