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
stow -t ~ zsh nvim npm atuin lazygit zellij tmux
```

Git identity is configured in place by `scripts/install.sh`; the `git/` directory is not Stow-managed. Carapace remains a core installed tool, but it has no Stow package.

Package ownership is conditional:

- On Ubuntu and Arch, the installer checks each real executable first, then uses Homebrew for missing core, user-facing, and language tools. The distro package manager is limited to system prerequisites needed before Homebrew is available.
- On Termux, packages continue to come from `pkg`; executable checks account for package/command differences such as `nodejs` providing `node`.
- `wezterm` and `zellij` are desktop-only Stow packages.
- `tmux` is stowed only when tmux is installed.
- Agent configuration (`pi-agent`, `opencode`, and `gemini`) is stowed only when the matching executable exists. On non-Termux systems the installer installs both standalone Pi (required by Gentle Shell) and Gentle Shell (`gentle-pi`), without a separate Gentle AI installation; the shared `pi-agent` profile is stowed when either `gentle-shell` or `pi` exists. Gentle Shell still reads profiles from `~/.pi/gentle-ai/profiles.json` by default. Termux retains standalone Pi. The installer does not restore dependencies inside agent directories; each agent owns its dependency lifecycle.
- `npm` is always stowed.
- `.termux/` and `scripts/` are not Stow-managed.

### Existing configuration migration

When `scripts/install.sh` first brings existing declarative configuration under Stow, it uses `stow --adopt` only for `npm`, `pi-agent`, and `opencode`, then restows each migrated package so the corresponding files in `HOME` become managed symlinks. Other packages use ordinary Stow and are never adopted automatically.

Adoption can update the repository copy with the pre-existing `HOME` content. Review the resulting Git diff before keeping or reverting those migrated values. Package-local `.stow-local-ignore` rules exclude sensitive data, runtime state, and installed dependencies from adoption; those files remain local and must not be added to the dotfiles repository.

`bash scripts/install.sh --dry-run` prints package installation, adoption, and restow commands without changing files or contacting the network.

## Ubuntu project runtime on Termux

The Termux installation provisions an Ubuntu 24.04 container through `proot-distro` and installs the Stow-managed `ubu` command. This provides Linux ARM64/glibc project tooling without adding compatibility configuration to individual repositories.

The initial runtime includes Node.js 24 and pnpm. Bun and background process management are intentionally not included.

Run commands from any Git repository or regular directory:

```bash
ubu run pnpm install --frozen-lockfile
ubu run pnpm dev
ubu run pnpm check
ubu run node --version
```

`ubu run` mounts the current Git worktree at `/workspace`, preserves the current relative directory, forwards the command exit status, and keeps interactive processes in the foreground so `Ctrl+C` stops them normally. Open an interactive guest shell or inspect the runtime with:

```bash
ubu shell
ubu doctor
```

Re-run the idempotent bootstrap after an interrupted installation or to repair missing tooling:

```bash
ubu setup
```

Project files remain in the Termux home directory. Project `node_modules` directories created through `ubu` contain Ubuntu/glibc dependencies, so all Node.js package-manager, formatter, linter, test, build, and development-server commands for those projects should also run through `ubu run`.

The Ubuntu root filesystem is managed by `proot-distro` outside this repository. To permanently remove it and all packages installed inside it:

```bash
proot-distro remove ubuntu
```

This removal is destructive and does not prompt for confirmation. It does not remove projects stored in the Termux home directory.

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
