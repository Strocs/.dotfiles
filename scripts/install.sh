#!/usr/bin/env bash
# install.sh — Instala las dependencias esenciales de los dotfiles en Termux y WSL.
# Uso: bash scripts/install.sh [--dry-run]
#
# Detecta automáticamente el entorno (Termux / WSL Ubuntu / WSL Arch)
# y utiliza Homebrew como gestor de paquetes principal cuando es posible.

set -euo pipefail

# ─── Colores ────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}▸${NC} $*"; }
ok()    { echo -e "${GREEN}✔${NC} $*"; }
warn()  { echo -e "${YELLOW}⚠${NC} $*"; }
fail()  { echo -e "${RED}✘${NC} $*"; exit 1; }
header(){ echo -e "\n${BOLD}${CYAN}── $* ──${NC}"; }

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

run() {
  if $DRY_RUN; then
    echo -e "  ${YELLOW}[dry-run]${NC} $*"
  else
    "$@"
  fi
}

# ─── Detectar entorno ──────────────────────────────────────────────────
detect_env() {
  if [[ -d "/data/data/com.termux" ]] && [[ -n "${PREFIX:-}" ]]; then
    ENV="termux"
  elif grep -qi microsoft /proc/version 2>/dev/null; then
    if command -v pacman &>/dev/null; then
      ENV="wsl-arch"
    else
      ENV="wsl-ubuntu"
    fi
  else
    ENV="linux"
  fi
  info "Entorno detectado: ${ENV}"
}

is_termux()  { [[ "$ENV" == "termux" ]]; }
is_brew()    { [[ "${BREW_AVAILABLE:-false}" == true ]]; }

# ─── 1. Pre-requisitos del sistema ─────────────────────────────────────
install_system_deps() {
  header "Dependencias del sistema"

  case "$ENV" in
    termux)
      run pkg update -y
      run pkg install -y \
        build-essential procps curl file git openssh \
        python3 xz-utils
      ;;
    wsl-ubuntu)
      run sudo apt-get update -y
      run sudo apt-get install -y \
        build-essential procps curl file git \
        xz-utils zip unzip \
        ca-certificates gnupg lsb-release
      ;;
    wsl-arch)
      run sudo pacman -Sy --noconfirm
      run sudo pacman -S --needed --noconfirm \
        base-devel procps curl file git \
        xz zip unzip
      ;;
    linux)
      warn "Entorno Linux genérico — se omite instalación de paquetes del sistema."
      ;;
  esac
  ok "Dependencias del sistema instaladas."
}

# ─── 2. Homebrew ───────────────────────────────────────────────────────
install_brew() {
  header "Homebrew"

  if command -v brew &>/dev/null; then
    ok "Ya instalado: $(brew --version | head -1)"
    BREW_AVAILABLE=true
    return
  fi

  if is_termux; then
    warn "Homebrew no es oficialmente soportado en Termux."
    warn "Se usará pkg para los paquetes restantes."
    BREW_AVAILABLE=false
    return
  fi

  info "Instalando Homebrew..."
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ -d "$HOME/.linuxbrew" ]]; then
    eval "$("$HOME/.linuxbrew/bin/brew shellenv")"
  fi

  BREW_AVAILABLE=true
  ok "Homebrew instalado."
}

# ─── 3. Herramientas core ──────────────────────────────────────────────
install_core_tools() {
  header "Herramientas core"

  # Estas SIEMPRE se instalan (zellij es el multiplexor default)
  CORE_PACKAGES=(
    stow
    zoxide
    atuin
    lazygit
    neovim
    fzf
    ripgrep
    fd
    carapace
    zellij
    gh
  )

  if is_brew; then
    for pkg in "${CORE_PACKAGES[@]}"; do
      if brew list "$pkg" &>/dev/null; then
        ok "  $pkg ya instalado"
      else
        info "  Instalando $pkg..."
        run brew install "$pkg"
      fi
    done
  else
    case "$ENV" in
      termux)
        for pkg in stow neovim fzf ripgrep fd-find lazygit zoxide atuin zellij gh; do
          if command -v "$pkg" &>/dev/null || dpkg -l "$pkg" &>/dev/null 2>&1; then
            ok "  $pkg ya instalado"
          else
            info "  Instalando $pkg via pkg..."
            run pkg install -y "$pkg" || warn "  $pkg no disponible en pkg — instalar manualmente"
          fi
        done
        if ! command -v carapace &>/dev/null; then
          info "  Instalando carapace desde GitHub releases..."
          run bash -c 'curl -fsSL https://carapace.dev/install.sh | bash'
        fi
        ;;
      *)
        for pkg in "${CORE_PACKAGES[@]}"; do
          command -v "$pkg" &>/dev/null || warn "  Instalar manualmente: $pkg"
        done
        ;;
    esac
  fi

  ok "Herramientas core listas."
}

# ─── 4. ZSH ────────────────────────────────────────────────────────────
install_zsh() {
  header "ZSH"

  if ! command -v zsh &>/dev/null; then
    info "Instalando zsh..."
    if is_brew; then
      run brew install zsh
    else
      case "$ENV" in
        termux) run pkg install -y zsh ;;
        wsl-ubuntu) run sudo apt-get install -y zsh ;;
        wsl-arch) run sudo pacman -S --needed --noconfirm zsh ;;
      esac
    fi
  fi
  ok "ZSH disponible."

  # Cambiar shell — Termux no soporta chsh ni /etc/shells
  if is_termux; then
    if ! grep -q "exec zsh" "$HOME/.bashrc" 2>/dev/null; then
      info "Agregando 'exec zsh' a ~/.bashrc para Termux..."
      if ! $DRY_RUN; then
        echo '' >> "$HOME/.bashrc"
        echo '# Activar zsh por defecto' >> "$HOME/.bashrc"
        echo 'exec zsh' >> "$HOME/.bashrc"
      fi
      ok "ZSH se activará automáticamente en Termux."
    else
      ok "ZSH ya configurado en Termux."
    fi
    return
  fi

  if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
    ZSH_PATH="$(command -v zsh)"
    if ! grep -qx "$ZSH_PATH" /etc/shells 2>/dev/null; then
      echo "$ZSH_PATH" | run sudo tee -a /etc/shells >/dev/null
    fi
    run chsh -s "$ZSH_PATH"
    ok "Shell por defecto cambiada a zsh."
  else
    ok "ZSH ya es la shell por defecto."
  fi
}

# ─── 5. Oh My Zsh ──────────────────────────────────────────────────────
install_ohmyzsh() {
  header "Oh My Zsh"

  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    ok "Ya instalado."
    return
  fi

  info "Instalando..."
  run sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  ok "Oh My Zsh instalado."
}

# ─── 6. Plugins ZSH ────────────────────────────────────────────────────
install_zsh_plugins() {
  header "Plugins ZSH"

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  declare -A ZSH_PLUGINS=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
    [zsh-ai]="https://github.com/matheusml/zsh-ai"
  )

  for name in "${!ZSH_PLUGINS[@]}"; do
    dest="$ZSH_CUSTOM/$name"
    if [[ -d "$dest" ]]; then
      ok "  $name ya instalado"
    else
      info "  Clonando $name..."
      run git clone "${ZSH_PLUGINS[$name]}" "$dest"
    fi
  done

  ok "Plugins ZSH instalados."
}

# ─── 7. Git config ─────────────────────────────────────────────────────
setup_git() {
  header "Git config"

  GITCONFIG="$HOME/.gitconfig"

  # Solo agregar si no existe configuración de usuario
  if [[ -f "$GITCONFIG" ]] && grep -q "name = " "$GITCONFIG" 2>/dev/null; then
    ok "Git ya configurado."
    return
  fi

  info "Configurando git con defaults útiles..."
  if ! $DRY_RUN; then
    cat > "$GITCONFIG" <<'GITCONF'
[user]
	name = Strocs
	email = strocsdev@gmail.com
[init]
	defaultBranch = main
[pull]
	rebase = true
[push]
	autoSetupRemote = true
[core]
	editor = nvim
[alias]
	st = status
	co = checkout
	br = branch
	cm = commit
	lg = log --oneline --graph --decorate -20
GITCONF
  fi
  ok "Git configurado."
}

# ─── 8. Tmux (opcional) ────────────────────────────────────────────────
install_tmux() {
  header "Tmux (opcional)"

  if ! command -v tmux &>/dev/null; then
    ok "Tmux no instalado — zellij es el multiplexor por defecto."
    return
  fi

  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    info "Instalando TPM para tmux..."
    run git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi

  ok "Tmux disponible. Para usarlo, edita WM_CMD en ~/.config/.zsh/wm.zsh"
}

# ─── 9. Lenguajes ──────────────────────────────────────────────────────
install_languages() {
  header "Herramientas de lenguaje"

  if is_brew; then
    for pair in "go:Go" "node:Node" "bun:Bun" "pnpm:pnpm"; do
      cmd="${pair%%:*}"
      name="${pair##*:}"
      if ! command -v "$cmd" &>/dev/null; then
        info "Instalando $name..."
        case "$cmd" in
          go)    run brew install go ;;
          node)  run brew install node ;;
          bun)   run brew install oven-sh/bun/bun ;;
          pnpm)  run brew install pnpm ;;
        esac
      else
        ok "$name ya instalado"
      fi
    done

    # Pi agent (vía pnpm)
    if ! command -v pi &>/dev/null; then
      info "Instalando pi agent..."
      run pnpm install -g @earendil-works/pi-coding-agent
    else
      ok "pi agent ya instalado"
    fi

    # Gentle AI (vía brew tap — no disponible en Termux)
    if ! is_termux; then
      if ! command -v gentle-ai &>/dev/null; then
        info "Instalando gentle-ai..."
        run brew install gentleman-programming/tap/gentle-ai
      else
        ok "gentle-ai ya instalado"
      fi
    fi
  else
    warn "Homebrew no disponible — instalar manualmente."
    echo "  Go:    https://go.dev/dl/"
    echo "  Node:  pkg install nodejs"
    echo "  Bun:   curl -fsSL https://bun.sh/install | bash"
    echo "  pnpm:  npm install -g pnpm"
    echo "  pi:    pnpm install -g @earendil-works/pi-coding-agent"
  fi

  ok "Herramientas de lenguaje listas."
}

# ─── 10. Aplicar dotfiles via stow ─────────────────────────────────────
apply_dotfiles() {
  header "Aplicando dotfiles"

  DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

  # Paquetes base — siempre se aplican
  STOW_PACKAGES=(zsh git nvim zellij npm)

  # tmux solo si está instalado
  if command -v tmux &>/dev/null; then
    STOW_PACKAGES+=(tmux)
  fi

  # wezterm solo en WSL
  if ! is_termux; then
    STOW_PACKAGES+=(wezterm)
  fi

  for pkg in "${STOW_PACKAGES[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
      info "Stowing $pkg..."
      run stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
      ok "  $pkg aplicado"
    else
      warn "  Paquete $pkg no encontrado — saltando"
    fi
  done

  ok "Dotfiles aplicados."
}

# ─── 11. SSH config ────────────────────────────────────────────────────
setup_ssh_config() {
  header "SSH config"

  SSH_DIR="$HOME/.ssh"
  SSH_CONFIG="$SSH_DIR/config"

  run mkdir -p "$SSH_DIR"
  run chmod 700 "$SSH_DIR"

  if [[ -f "$SSH_CONFIG" ]] && grep -q "Host strocs" "$SSH_CONFIG" 2>/dev/null; then
    ok "Entrada SSH para 'strocs' ya existe."
    return
  fi

  ENTRY=$(cat <<'SSHENTRY'

Host strocs
  HostName strocs
  User strocs
  StrictHostKeyChecking accept-new
SSHENTRY
)

  if ! $DRY_RUN; then
    echo "$ENTRY" >> "$SSH_CONFIG"
    chmod 600 "$SSH_CONFIG"
  else
    echo -e "  ${YELLOW}[dry-run]${NC} Agregar entrada SSH a $SSH_CONFIG"
  fi

  ok "SSH config actualizado."
}

# ─── 12. GitHub CLI auth ───────────────────────────────────────────────
setup_github() {
  header "GitHub CLI (gh)"

  if ! command -v gh &>/dev/null; then
    warn "gh no está instalado — saltando configuración de GitHub."
    return
  fi

  if gh auth status &>/dev/null 2>&1; then
    ok "GitHub CLI ya autenticado."
    return
  fi

  echo ""
  echo -e "  ${BOLD}GitHub CLI necesita autenticación.${NC}"
  echo ""
  echo "  Ejecuta en tu terminal:"
  echo ""
  echo -e "    ${CYAN}gh auth login${NC}"
  echo ""
  echo "  O con token:"
  echo ""
  echo -e "    ${CYAN}echo 'tu-token' | gh auth login --with-token${NC}"
  echo ""
  echo "  Permisos del token: repo, read:org, gist"
  echo ""
}

# ─── 13. Termux storage ────────────────────────────────────────────────
setup_termux_storage() {
  if ! is_termux; then
    return
  fi

  header "Termux Storage"

  if [[ -d "$HOME/storage" ]]; then
    ok "Termux storage ya configurado."
    return
  fi

  echo ""
  echo -e "  ${BOLD}Termux necesita acceso al almacenamiento.${NC}"
  echo ""
  echo "  Ejecuta en tu terminal:"
  echo ""
  echo -e "    ${CYAN}termux-setup-storage${NC}"
  echo ""
}

# ─── 14. Verificación ──────────────────────────────────────────────────
verify_installation() {
  header "Verificación"

  local errors=0

  # Verificar herramientas core
  for cmd in zsh git stow nvim zellij zoxide atuin lazygit fzf rg fd gh pnpm pi gentle-ai; do
    if command -v "$cmd" &>/dev/null; then
      ok "  $cmd"
    else
      warn "  $cmd NO encontrado"
      ((errors++))
    fi
  done

  # Verificar Oh My Zsh
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    ok "  oh-my-zsh"
  else
    warn "  oh-my-zsh NO encontrado"
    ((errors++))
  fi

  # Verificar plugins ZSH
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
  for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [[ -d "$ZSH_CUSTOM/$plugin" ]]; then
      ok "  $plugin"
    else
      warn "  $plugin NO encontrado"
      ((errors++))
    fi
  done

  # Verificar symlinks críticos
  for f in .zshrc .gitconfig; do
    if [[ -L "$HOME/$f" ]]; then
      ok "  $f (symlink)"
    else
      warn "  $f NO es symlink — stow no se aplicó correctamente"
      ((errors++))
    fi
  done

  if [[ $errors -eq 0 ]]; then
    ok "Todo verificado correctamente."
  else
    warn "$errors elementos con problemas — revisa arriba."
  fi
}

# ─── Resumen final ─────────────────────────────────────────────────────
summary() {
  echo ""
  echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  Instalación completada para: ${ENV}${NC}"
  echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
  echo ""
  echo -e "  ${BOLD}Multiplexor: zellij${NC} (wm.zsh → WM_CMD=\"zellij\")"
  echo ""
  echo -e "  ${BOLD}Siguientes pasos manuales:${NC}"
  echo ""
  echo "  1. Abre una nueva terminal (zsh)"
  echo "  2. Autentica GitHub CLI:"
  echo -e "       ${CYAN}gh auth login${NC}"
  if is_termux; then
    echo "  3. Configura storage:"
    echo -e "       ${CYAN}termux-setup-storage${NC}"
  fi
  echo ""
  echo -e "  ${BOLD}Aliases:${NC}"
  echo "    sshpc       ssh a la máquina principal"
  echo "    ocode       iniciar opencode server"
  echo "    lg          lazygit"
  echo "    nv          neovim"
  echo "    tconf       editar config de terminal"
  echo ""
  echo -e "  ${BOLD}Herramientas opcionales:${NC}"
  echo "    opencode    curl -fsSL https://opencode.ai/install | bash"
  echo "    turso       curl -sSfL https://get.tur.so/install.sh | bash"
  echo ""
}

# ─── Main ──────────────────────────────────────────────────────────────
main() {
  echo ""
  echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║         .Strocs — Instalador de Dotfiles                ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
  echo ""

  detect_env

  # Fase 1: Infraestructura
  install_system_deps
  install_brew
  install_core_tools

  # Fase 2: Shell
  install_zsh
  install_ohmyzsh
  install_zsh_plugins

  # Fase 3: Git
  setup_git

  # Fase 4: Multiplexor y lenguajes
  install_tmux
  install_languages

  # Fase 5: Aplicar configs
  apply_dotfiles
  setup_ssh_config

  # Fase 6: Auth y storage
  setup_github
  setup_termux_storage

  # Fase 7: Verificación
  verify_installation

  summary
}

main "$@"
