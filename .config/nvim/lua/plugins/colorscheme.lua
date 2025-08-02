return {
  {
    -- Plugin: sonokai
    -- URL: https://github.com/sainnhe/sonokai
    -- Description: High Contrast & Vivid Color Scheme based on Monokai Pro
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    name = "sonokai",
    config = function()
      vim.g.sonokai_style = "shusia"
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_transparent_background = 2
      vim.g.sonokai_diagnostic_virtual_text = "colored"
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      transparent = true,
      lualine_bold = true,
    },
  },
  {
    -- Implement theme by default
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
