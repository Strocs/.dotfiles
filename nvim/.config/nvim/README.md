# Personal configuration for Neovim.

This directory contains my personal configuration files for Neovim, focused on customizing the editor to suit my workflow and preferences, while starting with a minimal setup to better understand how Neovim works.

## Structure

- `init.lua`: The main configuration file that initializes Neovim and loads other modules.
- `lua/`: Directory containing Lua modules for various aspects of the configuration.
  - `config/`: Core Neovim settings and options.
    - `lazy.lua`: Initializes the lazy.nvim plugin manager and sets up plugin loading.
    - `keymaps.lua`: Defines custom key mappings for improved productivity.
    - `options.lua`: Configures general Neovim options like indentation, search, and UI settings.
  - `plugins/`: Contains individual plugin configurations, each in its own Lua file for modular management.

## Plugins

### Plugin Manager

- `folke/lazy.nvim`: A modern plugin manager for Neovim.

### LSP and Language Servers

- `williamboman/mason.nvim`: Portable package manager for Neovim.
- `neovim/nvim-lspconfig`: Quickstart configs for Neovim LSP.
- `williamboman/mason-lspconfig.nvim`: Extension for mason.nvim to manage LSP servers.

### Completion and Snippets

- `saghen/blink.cmp`: Fast and feature-rich completion plugin.
- `rafamadriz/friendly-snippets`: Snippets collection for completion.
- `zbirenbaum/copilot.lua`: GitHub Copilot integration for Neovim.

### Colorschemes

- `sainnhe/sonokai`: High contrast color scheme based on Monokai Pro.
- `folke/tokyonight.nvim`: A clean, dark Neovim theme.

### Mini Plugins

- `echasnovski/mini.pairs`: Automatic pair insertion for brackets and quotes.
- `echasnovski/mini.surround`: Manipulate surroundings (brackets, quotes, etc.).
- `echasnovski/mini.icons`: Icon provider for Neovim.

### Other Utilities

- `nvim-treesitter/nvim-treesitter`: Enhanced syntax highlighting and code parsing.
- `folke/snacks.nvim`: A collection of useful Neovim plugins, used here for find and search functionality.
- `stevearc/conform.nvim`: Code formatting plugin.
- `ThePrimeagen/harpoon`: File navigation and bookmarking tool.
- `OXY2DEV/markview.nvim`: Markdown preview and editing enhancements.
- `mfussenegger/nvim-lint`: Asynchronous linting for Neovim.
- `stevearc/oil.nvim`: File explorer that lets you edit your filesystem like a buffer.
- `christoomey/vim-tmux-navigator`: Seamless navigation between tmux panes and vim splits.
- `folke/trouble.nvim`: A pretty list for showing diagnostics, references, telescope results, quickfix and location lists.

## Configurations

Each plugin and feature is configured based on the main documentation, also taking some LazyVim configs and tweaking them to my needs.

