return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
    },
  },
  opts = {
    spec = {
      { "<leader>o", group = "Obsidian", icon = "🌱" },
      { "<leader>m", group = "Markdown" },
      { "<leader>ms", group = "Spell" },
      { "<leader>msl", group = "Language" },
    },
  },
}
