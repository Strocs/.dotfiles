return {
  {
    -- Plugin: nvim-lspconfig
    -- URL: https://github.com/neovim/nvim-lspconfig
    -- Description: Astro LSP config.
    "neovim/nvim-lspconfig",
    event = "VeryLazy", -- Load this plugin on the 'VeryLazy' event
    opts = {
      servers = {
        astro = {
          -- Add this to the astro lsp config:
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
              group = vim.api.nvim_create_augroup("astro_ondidchangetsorjsfile", { clear = true }),
              callback = function(ctx)
                client.notify("workspace/didChangeWatchedFiles", {
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
        },
      },
    },
  },
}
