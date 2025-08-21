return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  ft = { "markdown", "codecompanion" },
  opts = {
    heading = {
      enabled = true,
      sign = true,
      icons = { "① ", "② ", "③ ", "④ ", "⑤ ", "⑥ " },
      left_pad = 1,
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
      right_pad = 1,
      highlight = "render-markdownBullet",
    },
    latex = {
      enabled = false,
    },
  },
}
