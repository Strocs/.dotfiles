local TS = require 'nvim-treesitter'

TS.setup {
  ensure_installed = {
    'bash',
    'c',
    'diff',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'jsonc',
    'lua',
    'luadoc',
    'luap',
    'markdown',
    'markdown_inline',
    'printf',
    'python',
    'query',
    'regex',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
    'astro',
    'go',
  },
  sync_install = false,
  auto_install = true,

  indent = { enable = true },
  highlight = { enable = true },
  folds = { enable = true },
}

-- Treesitter Context
require('treesitter-context').setup {}

-- Auto-start treesitter on each buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('TreesitterInit', { clear = true }),
  callback = function()
    vim.defer_fn(function() pcall(vim.treesitter.start, vim.api.nvim_get_current_buf()) end, 10)
  end,
})

-- Autotag
require('nvim-ts-autotag').setup {}
