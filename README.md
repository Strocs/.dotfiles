# .Strocs

Dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/), designed to run on **Termux** and **Ubuntu/Arch Linux** (native or WSL) from a single repo.

## Platform model

All platform detection lives in **one file**: `zsh/.config/.zsh/platform.zsh`, loaded first from `.zshrc`. Everything else just consumes its variables.

| Variable | Values | Description |
|---|---|---|
| `PLATFORM` | `termux` / `ubuntu` / `arch` | Detected platform |
| `IS_TERMUX` | `true` / `false` | Exported so child processes (tmux, scripts) can read it |
| `IS_WSL` | `true` / `false` | WSL (Windows Subsystem for Linux) |
| `IS_DESKTOP` | `true` / `false` | Anything that is not Termux |
| `WM_CMD` | `zellij` / `tmux` / `none` | Multiplexer to launch when the terminal opens |
| `WM_CMD_IS_DEFAULT` | `true` / `false` | Whether `WM_CMD` was auto-picked or you forced it |

Per-platform defaults:

- **Termux:** `WM_CMD=none` (no multiplexer)
- **Desktop:** `WM_CMD=zellij`

To force another option, export it before zsh starts (e.g. in `~/.zshenv`):

```bash
export WM_CMD=tmux
```

## Pre-install

**Ubuntu/Arch:**

```bash
sudo apt-get install build-essential procps curl file git stow
```

**Termux:**

```bash
pkg install build-essential procps curl file git stow
```

## Install the repo

```bash
git clone <your-remote> ~/.dotfiles
cd ~/.dotfiles
stow -t ~ zsh git tmux atuin carapace lazygit nvim zellij
```

> Not stow-managed (ignored in `.stow-local-ignore`): `.termux/`, `wezterm/`, `scripts/` — platform-specific files you may want to link by hand instead.

## Shell: ZSH

**Desktop:**

```bash
brew install zsh
command -v zsh | sudo tee -a /etc/shells
chsh -s "$(command -v zsh)"
```

**Termux:**

```bash
pkg install zsh
chsh -s "$(command -v zsh)"
```

### Oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

The installer backs up your `.zshrc` to `.zshrc.pre-oh-my-zsh`; restore the symlink to your config afterwards:

```bash
rm ~/.zshrc && ln -s .dotfiles/zsh/.zshrc ~/.zshrc
```

### Zsh plugins

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/matheusml/zsh-ai ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-ai
```

### Secrets

Copy the template and fill in your keys (`zsh-ai` and other tools read them from there):

```bash
cp .dotfiles/zsh/.config/.zsh/.zsh_secrets.example ~/.config/.zsh/.zsh_secrets
```

Choose the `zsh-ai` provider in `zsh/.config/.zsh/plugins.zsh`: `ZSH_AI_PROVIDER="gemini"` (default) or `"ollama"` (local models).

## Terminal multiplexer

The multiplexer is decided by `WM_CMD` (see the platform model).

- **Zellij** (desktop default) — config in `zellij/`
- **tmux** — config in `tmux/`, with TPM:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# then C-Space + I inside tmux
```

## Tools

**Desktop:**

```bash
brew install stow carapace zoxide atuin lazygit neovim fzf ripgrep fd
```

**Termux:**

```bash
pkg install stow carapace zoxide atuin neovim fzf ripgrep fd
```

- Carapace (autocompletion)
- Zoxide (smart cd)
- Atuin (shell history)

Integrations (`zoxide init`, `atuin init`, carapace hook) activate automatically from `plugins.zsh`.

## Languages

#### Go

`brew install go` *(desktop)* / `pkg install golang` *(Termux)*

#### JavaScript / TypeScript

`brew install node@22 oven-sh/bun/bun`

#### Java

`brew install gradle`

## Platform notes

- `OBSIDIAN_VAULT_PATH` points to `/mnt/d/documents/StrocsVault/` on desktop and `~/storage/documents/obsidian-vault` on Termux (defined in `paths.zsh`).
- On WSL you also get the aliases `start` (explorer.exe) and `fxnet`; on Termux, `tconf` edits `termux.properties`.
