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

    -- Forzar inicialización de Treesitter highlight al abrir archivos
    -- Esto es necesario porque Treesitter highlight a veces no se inicia automáticamente
    -- Ver issues: nvim-treesitter#3767, nvim-treesitter#5750, nvim-treesitter#5207
    config = function(_, opts)
      local TS = require 'nvim-treesitter'
      TS.setup(opts)

      vim.api.nvim_create_autocmd('BufReadPost', {
        group = vim.api.nvim_create_augroup('TreesitterInit', { clear = true }),
        callback = function()
          vim.defer_fn(function()
            local ts_enabled, ts_status = pcall(vim.treesitter.start, vim.api.nvim_get_current_buf())
            if not ts_enabled then
              print('Treesitter highlight no pudo inicializarse automáticamente')
            end
          end, 10)
        end,
      })
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
}
