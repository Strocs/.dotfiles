return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
        go = { "gofmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        sql = { "sqlfluff" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = { "-style=file", "-fallback-style=LLVM" },
        },
        sqlfluff = {
          args = { "format", "-" },
          timeout_ms = 60000,
        },
      },
      format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
      },
    })

    -- Keymap for manual formatting (outside of setup)
    vim.keymap.set("n", "<leader>f", function()
      require("conform").format({ async = true })
    end, { desc = "Format buffer with conform" })
  end,
}
