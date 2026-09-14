# .Strocs

Dotfiles personales para **WSL** (Ubuntu/Arch) y **Termux** (Android). Un solo repositorio, detección automática del entorno.

## Estructura

```
.dotfiles/
├── nvim/          # Neovim config (pack manager nativo)
├── zsh/           # ZSH config (Oh My Zsh + plugins)
├── tmux/          # Tmux config + TPM
├── git/           # Git global config
├── lazygit/       # Lazygit config
├── wezterm/       # WezTerm config (solo WSL)
├── zellij/        # Zellij config
├── scripts/       # Scripts de instalación y utilidades
└── atuin/         # Atuin config
```

## Instalación rápida

```bash
git clone https://github.com/strocs/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash scripts/install.sh
```

El script detecta automáticamente tu entorno e instala todo lo necesario:

| Entorno | Detecta por | Gestor de paquetes |
|---------|-------------|-------------------|
| Termux | `/data/data/com.termux` | `pkg` (brew no soportado oficialmente) |
| WSL Ubuntu | `microsoft` en `/proc/version` + `apt` | `brew` (primario) + `apt` (fallback) |
| WSL Arch | `microsoft` en `/proc/version` + `pacman` | `brew` (primario) + `pacman` (fallback) |

Opciones:
- `--dry-run` — muestra qué haría sin ejecutar nada

## Instalación manual

Si prefieres instalar paso a paso:

### 1. Pre-requisitos del sistema

**Ubuntu/Debian (WSL):**
```bash
sudo apt-get install build-essential procps curl file git xz-utils zip unzip
```

**Arch (WSL):**
```bash
sudo pacman -S --needed base-devel procps curl file git xz zip unzip
```

**Termux:**
```bash
pkg install build-essential procps curl file git openssh
```

### 2. Homebrew (WSL solamente)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

> Homebrew **no** se usa en Termux — los paquetes se instalan directo con `pkg`.

### 3. Herramientas core

**Con brew (WSL):**
```bash
brew install stow zoxide atuin lazygit neovim fzf ripgrep fd carapace tmux zellij
```

**Con pkg (Termux):**
```bash
pkg install stow neovim fzf ripgrep fd-find lazygit zoxide atuin tmux zellij
# carapace: instalar desde https://carapace.dev
```

### 4. ZSH

```bash
# Instalar zsh
brew install zsh        # WSL
pkg install zsh         # Termux

# Cambiar shell por defecto
command -v zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/zsh-syntax-highlighting"
git clone https://github.com/matheusml/zsh-ai "$ZSH_CUSTOM/zsh-ai"
```

### 5. Tmux (opcional)

Tmux se instala como alternativa a zellij (default). Si lo usas:

```bash
# TPM se instala automáticamente en el script
# Dentro de tmux: C-Space + I para instalar plugins
```

Para cambiar a tmux, edita `~/.config/.zsh/wm.zsh`:
```bash
WM_CMD="tmux"
```

### 6. Aplicar dotfiles

```bash
cd ~/.dotfiles
stow -t ~ zsh git tmux nvim zellij   # Paquetes base
stow -t ~ wezterm                    # Solo en WSL
```

### 7. Herramientas de lenguaje (opcional)

```bash
brew install go node oven-sh/bun/bun   # WSL
```

## Entornos soportados

### WSL (Ubuntu / Arch)

- **Shell**: ZSH con Oh My Zsh
- **Terminal**: WezTerm
- **Multiplexor**: Zellij (default, configurable en `wm.zsh`)
- **Editor**: Neovim
- **Alias relevantes**:
  - `sshpc` — SSH a la máquina principal (`ssh strocs@strocs`)
  - `ocode` — Iniciar opencode server
  - `lg` — Lazygit
  - `tconf` — Editar config de WezTerm

### Termux (Android)

- **Shell**: ZSH con Oh My Zsh
- **Multiplexor**: Zellij (default, configurable en `wm.zsh`)
- **Editor**: Neovim
- **Storage**: Ejecutar `termux-setup-storage` para acceder a archivos del dispositivo
- **Alias relevantes**:
  - `sshpc` — SSH a la máquina principal
  - `tconf` — Editar `termux.properties`
  - `ov` — Navegar al vault de Obsidian

### Detección de entorno

El archivo `paths.zsh` detecta automáticamente Termux:
```bash
if [ -d "/data/data/com.termux" ] && [ -n "$PREFIX" ]; then
   export IS_TERMUX=true
fi
```

Las funciones y aliases que dependen del entorno (WSL-only, systemctl, etc.) están protegidos con guards `[[ -z "$IS_TERMUX" ]]`.

## Archivos importantes

| Archivo | Propósito |
|---------|-----------|
| `zsh/.zshrc` | Entry point de ZSH — carga los archivos en orden |
| `zsh/.config/.zsh/paths.zsh` | Variables de entorno y PATH (Termux-aware) |
| `zsh/.config/.zsh/general.zsh` | Tema, editor, XDG_RUNTIME_DIR |
| `zsh/.config/.zsh/plugins.zsh` | Config de Oh My Zsh, zoxide, atuin, carapace |
| `zsh/.config/.zsh/aliases.zsh` | Todos los aliases (WSL/Termux separados) |
| `zsh/.config/.zsh/wm.zsh` | Auto-start de zellij/tmux |
| `nvim/.config/nvim/lua/config/plugins.lua` | Declaración centralizada de plugins |
| `npm/.npmrc` | Seguridad npm (`ignore-scripts=true`) |
| `scripts/install.sh` | Instalador automático |

## SSH a desktop

El alias `sshpc` conecta directamente a la máquina principal:

```bash
sshpc            # equivale a: ssh strocs@strocs
```

Asegúrate de que la máquina principal tenga SSH habilitado y el hostname `strocs` resuelva correctamente (via `/etc/hosts`, mDNS, o Tailscale).

## Post-instalación

Después de ejecutar `scripts/install.sh`, hay pasos manuales que requieren tu intervención:

### GitHub CLI

```bash
gh auth login
# Seleccionar: GitHub.com > HTTPS > Login with a web browser
```

O autenticación no interactiva:
```bash
echo "tu-token-aqui" | gh auth login --with-token
```

Permisos recomendados del token: `repo`, `read:org`, `gist`

### Termux (solo Android)

```bash
termux-setup-storage
# Otorga acceso a: documents, downloads, pictures, music, movies
```

### Tmux (solo si lo usas)

Dentro de tmux:
```
C-Space + I    # Instalar plugins via TPM
```

### Zellij (default)

Zellij se inicia automáticamente al abrir la terminal (via `wm.zsh`). No necesita pasos adicionales.

Plugins incluidos: `zjstatus`, `vim-zellij-navigator`, `tab-names` hook.

## Actualizar

```bash
cd ~/.dotfiles
git pull
stow -t ~ -R zsh git tmux nvim zellij npm   # Re-stow para aplicar cambios
```
