return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      sqlfluff = {
        -- Quitar --dialect=ansi para que use el .sqlfluff del proyecto
        args = { "format", "-" },
      },
    },
    formatters_by_ft = {
      sql = { "sqlfluff", timeout_ms = 60000 },
    },
  },
}
