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

-- Modern ensure_installed (no-op if already installed, async)
require('nvim-treesitter').install {
  'typescript',
  'tsx',
  'javascript',
  'jsdoc',
  'html',
  'css',
  'json',
  'markdown',
  'markdown_inline',
  'astro',
  'lua',
  'luadoc',
  'luap',
  'yaml',
  'bash',
  'c',
  'python',
  'go',
  'regex',
}
