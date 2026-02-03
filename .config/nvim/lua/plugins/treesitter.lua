return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',

    dependencies = { 'nvim-treesitter/nvim-treesitter-context' },
    opts_extend = { 'ensure_installed' },

    opts = {
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

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
    },

    config = function(_, opts)
      local TS = require 'nvim-treesitter'
      TS.setup(opts)

      vim.api.nvim_create_autocmd('BufReadPost', {
        group = vim.api.nvim_create_augroup('TreesitterInit', { clear = true }),
        callback = function()
          vim.defer_fn(function() pcall(vim.treesitter.start, vim.api.nvim_get_current_buf()) end, 10)
        end,
      })
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
}
