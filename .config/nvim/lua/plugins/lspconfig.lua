return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Forcefully disable all TypeScript servers except vtsls
    opts.servers = opts.servers or {}

    -- Disable LazyVim's default TypeScript servers
    opts.servers.tsserver = false
    opts.servers.ts_ls = false
    opts.servers.typescript_language_server = false

    -- Configure vtsls with memory optimizations
    opts.servers.vtsls = {
      cmd = {
        "vtsls",
        "--stdio",
        "--tsserver-max-memory=1024",
      },
      settings = {
        typescript = {
          workspaceSymbols = {
            scope = "currentProject",
          },
        },
        vtsls = {
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = false,
            },
          },
        },
      },
    }

    opts.inlay_hints = opts.inlay_hints or {}
    opts.inlay_hints.enabled = false

    return opts
  end,
}
