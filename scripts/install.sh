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
  elif [[ -r /etc/os-release ]]; then
    . /etc/os-release
    case "${ID:-}" in
      ubuntu) ENV="ubuntu" ;;
      arch) ENV="arch" ;;
      *) fail "Distribución no soportada: ${ID:-unknown}" ;;
    esac
  else
    fail "No se pudo detectar una distribución soportada."
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
        proot-distro python3 xz-utils
      ;;
    ubuntu)
      run sudo apt-get update -y
      run sudo apt-get install -y \
        build-essential procps curl file git \
        xz-utils zip unzip \
        ca-certificates gnupg lsb-release fd-find
      ;;
    arch)
      run sudo pacman -Syu --needed --noconfirm \
        base-devel procps-ng curl file git \
        xz zip unzip ca-certificates
      ;;
    *)
      fail "Entorno no soportado: $ENV" ;;
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
  if $DRY_RUN; then
    echo -e "  ${YELLOW}[dry-run]${NC} descargar y ejecutar el instalador oficial de Homebrew"
    # Continue through the Homebrew branches so dry-run shows the full plan.
    BREW_AVAILABLE=true
    return
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ -d "$HOME/.linuxbrew" ]]; then
    eval "$("$HOME/.linuxbrew/bin/brew shellenv")"
  fi

  BREW_AVAILABLE=true
  ok "Homebrew instalado."
}

# ─── 3. Multiplexers opcionales (via brew) ────────────────────────────
install_optional_multiplexers() {
  header "Multiplexers opcionales (via brew)"

  if ! is_brew; then
    info "Homebrew no disponible — saltando multiplexers opcionales"
    return
  fi

  # zellij
  if ! command -v zellij &>/dev/null; then
    info "Instalando zellij via brew..."
    run brew install zellij
  else
    ok "zellij ya instalado"
  fi

  # tmux
  if ! command -v tmux &>/dev/null; then
    info "Instalando tmux via brew..."
    run brew install tmux
  else
    ok "tmux ya instalado"
  fi

  # herdr
  if ! command -v herdr &>/dev/null; then
    info "Instalando herdr via brew..."
    run brew install herdr
  else
    ok "herdr ya instalado"
  fi
}

# ─── 4. Herramientas core ──────────────────────────────────────────────
install_core_tools() {
  header "Herramientas core"

  # Estas herramientas se instalan en todos los entornos soportados.
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
    gh
  )

  if is_brew; then
    local pair pkg cmd
    for pair in \
      "stow:stow" "zoxide:zoxide" "atuin:atuin" "lazygit:lazygit" \
      "neovim:nvim" "fzf:fzf" "ripgrep:rg" "fd:fd" \
      "carapace:carapace" "gh:gh"; do
      pkg="${pair%%:*}"
      cmd="${pair##*:}"
      if command -v "$cmd" &>/dev/null; then
        ok "  $pkg ya instalado ($cmd)"
      else
        info "  Instalando $pkg..."
        run brew install "$pkg"
      fi
    done
  else
    case "$ENV" in
      termux)
        local pair pkg cmd
        for pair in \
          "stow:stow" "neovim:nvim" "fzf:fzf" "ripgrep:rg" "fd:fd" \
          "lazygit:lazygit" "zoxide:zoxide" "atuin:atuin" "gh:gh" \
          "carapace:carapace" "pnpm:pnpm"; do
          pkg="${pair%%:*}"
          cmd="${pair##*:}"
          if command -v "$cmd" &>/dev/null; then
            ok "  $pkg ya instalado ($cmd)"
          else
            info "  Instalando $pkg via pkg..."
            run pkg install -y "$pkg" || warn "  $pkg no disponible en pkg — instalar manualmente"
          fi
        done
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
        ubuntu) run sudo apt-get install -y zsh ;;
        arch) run sudo pacman -S --needed --noconfirm zsh ;;
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
    ZSH_PATH="$(command -v zsh || true)"
    if [[ -z "$ZSH_PATH" ]]; then
      case "$ENV" in
        ubuntu|arch) ZSH_PATH="/usr/bin/zsh" ;;
        *) ZSH_PATH="zsh" ;;
      esac
    fi
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
  if $DRY_RUN; then
    echo -e "  ${YELLOW}[dry-run]${NC} descargar y ejecutar el instalador oficial de Oh My Zsh --unattended"
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  ok "Oh My Zsh instalado."
}

# ─── 6. Plugins ZSH ────────────────────────────────────────────────────
install_zsh_plugins() {
  header "Plugins ZSH"

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  ZSH_PLUGIN_DIR="$ZSH_CUSTOM/plugins"

  declare -A ZSH_PLUGINS=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
    [zsh-ai]="https://github.com/matheusml/zsh-ai"
  )

  for name in "${!ZSH_PLUGINS[@]}"; do
    dest="$ZSH_PLUGIN_DIR/$name"
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

  local git_name="Ignacio Molina Palominos"
  local git_email="strocsdev@gmail.com"

  info "Normalizando la identidad global de Git sin alterar otras opciones..."
  if $DRY_RUN; then
    echo -e "  ${YELLOW}[dry-run]${NC} git config --global --replace-all user.name '$git_name'"
    echo -e "  ${YELLOW}[dry-run]${NC} git config --global --replace-all user.email '$git_email'"
  else
    git config --global --replace-all user.name "$git_name"
    git config --global --replace-all user.email "$git_email"
  fi
  ok "Identidad global de Git configurada."
}

# ─── 8. Tmux (opcional) ────────────────────────────────────────────────
install_tmux() {
  header "Tmux (opcional)"

  if ! command -v tmux &>/dev/null; then
    ok "Tmux no instalado."
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

    # Gentle Shell requires the standalone Pi executable; install it first.
    if ! command -v pi &>/dev/null; then
      info "Instalando pi agent..."
      run pnpm install -g @earendil-works/pi-coding-agent
    else
      ok "pi agent ya instalado"
    fi

    if ! command -v gentle-shell &>/dev/null; then
      info "Instalando gentle-shell..."
      run pnpm install -g gentle-pi
    else
      ok "gentle-shell ya instalado"
    fi
  elif is_termux; then
    if ! command -v node &>/dev/null; then
      info "Instalando nodejs via pkg..."
      run pkg install -y nodejs
    else
      ok "Node ya instalado"
    fi
    if ! command -v pi &>/dev/null; then
      run pnpm install -g @earendil-works/pi-coding-agent
    fi
  else
    warn "Gestor de paquetes no disponible — instalar manualmente."
    echo "  Go:    https://go.dev/dl/"
    echo "  Node:  instalar mediante el gestor de paquetes de la distribución"
    echo "  Bun:   curl -fsSL https://bun.sh/install | bash"
    echo "  pnpm:  npm install -g pnpm"
    echo "  pi:           pnpm install -g @earendil-works/pi-coding-agent"
    echo "  gentle-shell: pnpm install -g gentle-pi"
  fi

  ok "Herramientas de lenguaje listas."
}

# ─── 10. Runtime Ubuntu para Termux ────────────────────────────────────
setup_ubu_runtime() {
  if ! is_termux; then
    return
  fi

  header "Runtime Ubuntu para proyectos"

  local dotfiles_dir bootstrap_script
  dotfiles_dir="$(cd "$(dirname "$0")/.." && pwd)"
  bootstrap_script="$dotfiles_dir/scripts/install-ubu-termux.sh"

  if [[ ! -x "$bootstrap_script" ]]; then
    fail "Bootstrap de ubu no encontrado o no ejecutable: $bootstrap_script"
  fi

  if $DRY_RUN; then
    "$bootstrap_script" --dry-run
  else
    "$bootstrap_script"
  fi

  ok "Runtime Ubuntu listo."
}

# ─── 11. Aplicar dotfiles via stow ─────────────────────────────────────
apply_dotfiles() {
  header "Aplicando dotfiles"

  DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

  # Paquetes base — zellij solo se aplica fuera de Termux
  # setup_git owns ~/.gitconfig; do not let Stow replace an existing host config.
  STOW_PACKAGES=(zsh nvim npm atuin lazygit agent-skills)
  if is_termux; then
    STOW_PACKAGES+=(agents ubu)
  else
    STOW_PACKAGES+=(zellij)
  fi

  # tmux solo si está instalado
  if command -v tmux &>/dev/null; then
    STOW_PACKAGES+=(tmux)
  fi

  # herdr solo si está instalado (via brew o manual)
  if command -v herdr &>/dev/null; then
    STOW_PACKAGES+=(herdr)
  fi

  # The shared profile is consumed by Gentle Shell or a standalone Pi installation.
  if command -v gentle-shell &>/dev/null || command -v pi &>/dev/null; then
    STOW_PACKAGES+=(pi-agent)
  fi
  if command -v opencode &>/dev/null && [[ -d "$DOTFILES_DIR/opencode" ]]; then
    STOW_PACKAGES+=(opencode)
  fi
  if command -v gemini &>/dev/null && [[ -d "$DOTFILES_DIR/gemini" ]]; then
    STOW_PACKAGES+=(gemini)
  fi

  # These packages may already have declarative files in HOME from before Stow.
  # Adoption is intentionally limited to this migration set; package-local
  # .stow-local-ignore files keep sensitive, runtime, and dependency paths local.
  local adoption_packages=(npm pi-agent opencode agent-skills)
  local needs_adoption candidate
  local -a stow_options

  for pkg in "${STOW_PACKAGES[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
      warn "  Paquete $pkg no encontrado — saltando"
      continue
    fi

    # Pi keeps runtime files beside the managed profile. Prevent directory
    # folding so package-local ignores are honored file by file.
    stow_options=()
    if [[ "$pkg" == "pi-agent" ]]; then
      stow_options+=(--no-folding)
    fi

    needs_adoption=false
    for candidate in "${adoption_packages[@]}"; do
      if [[ "$pkg" == "$candidate" ]]; then
        needs_adoption=true
        break
      fi
    done

    if $needs_adoption; then
      info "Adoptando archivos declarativos existentes para $pkg..."
      if ! run stow "${stow_options[@]}" --adopt -d "$DOTFILES_DIR" -t "$HOME" "$pkg"; then
        fail "Falló la adopción de Stow para el paquete: $pkg"
      fi
      info "Restowing $pkg para asegurar enlaces administrados..."
      if ! run stow "${stow_options[@]}" --restow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"; then
        fail "Falló el restow de Stow para el paquete: $pkg"
      fi
    else
      info "Stowing $pkg..."
      if ! run stow "${stow_options[@]}" -d "$DOTFILES_DIR" -t "$HOME" "$pkg"; then
        fail "Falló Stow para el paquete: $pkg"
      fi
    fi
    ok "  $pkg aplicado"
  done

  ok "Dotfiles aplicados."
}

# ─── 12. SSH config ────────────────────────────────────────────────────
setup_ssh_config() {
  header "SSH config"

  SSH_DIR="$HOME/.ssh"
  SSH_CONFIG="$SSH_DIR/config"
  local target_host expected_host host_value user_value port_value

  run mkdir -p "$SSH_DIR"
  run chmod 700 "$SSH_DIR"

  if is_termux; then
    target_host="desktop"
    expected_host="desktop"
    host_value="${SSH_DESKTOP_HOST:-}"
  else
    target_host="strocs"
    expected_host="strocs"
    host_value="${SSH_TERMUX_HOST:-}"
  fi

  # Do not invent addresses or overwrite an existing personal config.
  if [[ -f "$SSH_CONFIG" ]] && grep -qE "^[[:space:]]*Host[[:space:]]+$expected_host([[:space:]]|$)" "$SSH_CONFIG"; then
    user_value=$(awk -v h="$expected_host" '
      $1 == "Host" { active=($2 == h) }
      active && $1 == "User" { print $2; exit }
    ' "$SSH_CONFIG")
    port_value=$(awk -v h="$expected_host" '
      $1 == "Host" { active=($2 == h) }
      active && $1 == "Port" { print $2; exit }
    ' "$SSH_CONFIG")
    if [[ -n "$user_value" && ( -z "$port_value" || "$port_value" == 22 ) ]]; then
      ok "Entrada SSH para '$target_host' ya existe y parece válida."
    else
      warn "Entrada SSH '$target_host' existe, pero requiere revisión (User/Port)."
    fi
    return
  fi

  if [[ -z "$host_value" ]]; then
    warn "No existe 'Host $target_host'. No se agregará una dirección automáticamente."
    if is_termux; then
      warn "Definir SSH_DESKTOP_HOST antes de ejecutar para crearla."
    else
      warn "Definir SSH_TERMUX_HOST antes de ejecutar para crearla."
    fi
    return
  fi

  local entry="
Host $target_host
  HostName $host_value
  User strocs
  Port 22
  StrictHostKeyChecking accept-new
"
  if ! $DRY_RUN; then
    printf '%s\n' "$entry" >> "$SSH_CONFIG"
    chmod 600 "$SSH_CONFIG"
  else
    echo -e "  ${YELLOW}[dry-run]${NC} Agregar entrada SSH '$target_host' a $SSH_CONFIG"
  fi
  ok "SSH config actualizado para '$target_host'."
}

# ─── 12. GitHub CLI auth ───────────────────────────────────────────────
setup_github() {
  header "GitHub CLI (gh)"

  if ! command -v gh &>/dev/null; then
    warn "gh no está instalado — saltando configuración de GitHub."
    return
  fi

  if ! $DRY_RUN && gh auth status &>/dev/null 2>&1; then
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

  # Stow may have just installed user executables in this non-login shell.
  export PATH="$HOME/.local/bin:$PATH"

  if $DRY_RUN; then
    warn "Verificación omitida en --dry-run; no se instalaron paquetes realmente."
    return 0
  fi

  local errors=0

  # Verificar herramientas core (zellij no forma parte de Termux)
  local core_commands=(zsh git stow nvim zoxide atuin lazygit fzf rg gh pnpm)
  core_commands+=(pi)
  if ! is_termux; then
    core_commands+=(gentle-shell zellij herdr tmux)
  fi
  if is_termux; then
    core_commands+=(proot-distro ubu)
  fi
  for cmd in "${core_commands[@]}"; do
    if command -v "$cmd" &>/dev/null; then
      ok "  $cmd"
    else
      warn "  $cmd NO encontrado"
      ((errors += 1))
    fi
  done

  # fd se llama fdfind en Ubuntu/Debian y fd en Termux/Arch/Brew.
  if command -v fd &>/dev/null || command -v fdfind &>/dev/null; then
    ok "  fd"
  else
    warn "  fd NO encontrado"
    ((errors += 1))
  fi

  if is_termux; then
    if ubu doctor --quiet; then
      ok "  runtime de ubu"
    else
      warn "  runtime de ubu NO disponible"
      ((errors += 1))
    fi
  fi

  # Verificar Oh My Zsh
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    ok "  oh-my-zsh"
  else
    warn "  oh-my-zsh NO encontrado"
    ((errors += 1))
  fi

  # Verificar plugins ZSH
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
      ok "  $plugin"
    else
      warn "  $plugin NO encontrado"
      ((errors += 1))
    fi
  done

  if is_termux; then
    if [[ -L "$HOME/dev/AGENTS.md" ]]; then
      ok "  dev/AGENTS.md (symlink)"
    else
      warn "  dev/AGENTS.md NO es symlink — stow no se aplicó correctamente"
      ((errors += 1))
    fi
  fi

  # ~/.gitconfig is intentionally managed in place by setup_git, not by Stow.
  # Verify only dotfiles that retain symlink ownership.
  for f in .zshrc; do
    if [[ -L "$HOME/$f" ]]; then
      ok "  $f (symlink)"
    else
      warn "  $f NO es symlink — stow no se aplicó correctamente"
      ((errors += 1))
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
  if is_termux; then
    echo -e "  ${BOLD}Multiplexor: ninguno${NC} (Termux; WM_CMD=\"none\")"
  else
    echo -e "  ${BOLD}Multiplexor: herdr${NC} (wm.zsh → WM_CMD=\"herdr\")"
  fi
  echo ""
  echo -e "  ${BOLD}Siguientes pasos manuales:${NC}"
  echo ""
  echo "  1. Abre una nueva terminal (zsh)"
  echo "  2. Autentica GitHub CLI:"
  echo -e "       ${CYAN}gh auth login${NC}"
  if is_termux; then
    echo "  3. Configura storage:"
    echo -e "       ${CYAN}termux-setup-storage${NC}"
    echo ""
    echo -e "  ${BOLD}Runtime Ubuntu para proyectos:${NC}"
    echo -e "       ${CYAN}ubu run pnpm dev${NC}"
    echo -e "       ${CYAN}ubu shell${NC}"
    echo -e "       ${CYAN}ubu doctor${NC}"
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
  install_optional_multiplexers
  install_core_tools

  # Fase 2: Shell
  install_zsh
  install_ohmyzsh
  install_zsh_plugins

  # Fase 3: Git
  setup_git

  # Fase 4: Multiplexor, lenguajes y runtime de proyectos
  install_tmux
  install_languages
  setup_ubu_runtime

  # Fase 5: Aplicar configs declarativas; cada agente gestiona sus dependencias.
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
