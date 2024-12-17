return {
  -- Plugin: lualine.nvim
  -- URL: https://github.com/nvim-lualine/lualine.nvim
  -- Description: A blazing fast and easy to configure Neovim statusline plugin.
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      -- Remove the right clock
      lualine_z = {},
    },
  },
}
