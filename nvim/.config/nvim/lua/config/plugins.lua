-- Centralized plugin declarations.
-- All vim.pack.add() calls live here so that every plugin is registered
-- and loaded before after/plugin/ files try to configure them.

vim.pack.add({
  'https://github.com/sainnhe/sonokai',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/khoido2003/monokai-v2.nvim',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/rafamadriz/friendly-snippets',
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.1' },
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/MagicDuck/grug-far.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/sudo-tee/opencode.nvim',
  'https://github.com/chrisgrieser/nvim-rip-substitute',
  'https://github.com/swaits/zellij-nav.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/folke/trouble.nvim',
}, {
  load = true,
})
