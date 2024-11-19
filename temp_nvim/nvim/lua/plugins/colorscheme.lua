return {
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    name = "sonokai",
    config = function()
      vim.g.sonokai_style = "shusia"
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_transparent_background = 2
    end,
  },
  {
    "shaunsingh/moonlight.nvim",
    lazy = false,
    priority = 1000,
    name = "moonlight",
    config = function()
      vim.g.moonlight_disable_background = true
    end,
  },
  -- {
  --   "AlexvZyl/nordic.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("nordic").setup({
  --       on_palette = function(palette)
  --         return palette
  --       end,
  --       transparent = true,
  --     })
  --   end,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "sonokai",
    },
  },
}
