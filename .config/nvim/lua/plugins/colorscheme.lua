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
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "sonokai",
    },
  },
}
