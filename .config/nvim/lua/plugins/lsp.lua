-- LSP configuration using modern Neovim 0.11+ vim.lsp.config() API
-- This is the recommended approach for Neovim 0.11+
-- Reference: https://neovim.io/doc/user/lsp.html

return {
  {
    'williamboman/mason.nvim',
    opts = {},
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },

    config = function()
      -- lua_ls with custom settings and globals
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      -- Astro LSP with on_attach to watch ts/js files
      vim.lsp.config('astro', {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd('BufWritePost', {
            pattern = { '*.js', '*.ts', '*.jsx', '*.tsx' },
            group = vim.api.nvim_create_augroup('astro_ondidchangetsorjsfile', { clear = true }),
            callback = function(ctx)
              client.notify('workspace/didChangeWatchedFiles', {
                changes = {
                  {
                    uri = vim.uri_from_fname(ctx.match),
                    type = 2, -- 1 = Created, 2 = Changed, 3 = Deleted
                  },
                },
              })
            end,
          })
        end,
      })

      -- Setup Mason and Mason-lspconfig
      -- require('mason').setup()

      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls',
        },
      }

      -- LSP keymaps setup
      -- These are configured on LspAttach to ensure LSP is available
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(e)
          local opts = { buffer = e.buf, noremap = true, silent = true }

          -- Navigation
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

          -- Documentation and hover
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>K', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)

          -- Workspace and symbols
          vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
          vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)

          -- Diagnostics
          vim.keymap.set('n', '<leader>xx', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)

          -- Code actions
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('x', '<leader>ca', vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
}
