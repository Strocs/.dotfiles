local theme = 'tokyonight'

return {
  {
    'sainnhe/sonokai',
    lazy = false,
    priority = 1000,
    name = 'sonokai',
    config = function()
      vim.g.sonokai_style = 'shusia'
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_transparent_background = 2
      vim.g.sonokai_diagnostic_virtual_text = 'colored'

      if theme ~= 'sonokai' then return end
      vim.cmd.colorscheme 'sonokai'
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      lualine_bold = true,
      styles = {
        floats = 'transparent',
      },
    },
    config = function()
      if theme ~= 'tokyonight' then return end
      vim.cmd.colorscheme 'tokyonight'
    end,
  },
  {
    'khoido2003/monokai-v2.nvim',
    priority = 1000,
    config = function()
      if theme ~= 'monokai' then return end
      require('monokai-v2').setup {
        transparent_background = true,
        filter = 'spectrum',
      }
      vim.cmd 'colorscheme monokai-v2'
    end,
  },
}
