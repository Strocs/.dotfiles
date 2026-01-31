return {
  'stevearc/conform.nvim',
  dependencies = { 'mason.nvim' },
  lazy = true,
  cmd = 'ConformInfo',
  event = { 'BufReadPost', 'BufNewFile' },

  keys = {
    {
      '<leader>f',
      function() require('conform').format() end,
      mode = { 'n', 'x' },
      desc = 'Format buffer with conform',
    },
  },

  config = function()
    require('conform').setup {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        c = { 'clang-format' },
        lua = { 'stylua' },
        go = { 'gofmt' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        sql = { 'sqlfluff' },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        ['clang-format'] = {
          prepend_args = { '-style=file', '-fallback-style=LLVM' },
        },
        sqlfluff = {
          args = { 'format', '-' },
          timeout_ms = 60000,
        },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = 'fallback',
      },
    }
  end,
}
