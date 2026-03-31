vim.pack.add {
  'https://github.com/sainnhe/sonokai',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/khoido2003/monokai-v2.nvim',
}

local theme = 'tokyonight'

-- Sonokai
vim.g.sonokai_style = 'shusia'
vim.g.sonokai_better_performance = 1
vim.g.sonokai_transparent_background = 2
vim.g.sonokai_diagnostic_virtual_text = 'colored'

if theme == 'sonokai' then
  vim.cmd.colorscheme 'sonokai'
end

-- Tokyonight
require('tokyonight').setup {
  transparent = true,
  lualine_bold = true,
  styles = {
    floats = 'transparent',
  },
}

if theme == 'tokyonight' then
  vim.cmd.colorscheme 'tokyonight'
end

-- Monokai V2
require('monokai-v2').setup {
  transparent_background = true,
  filter = 'spectrum',
}

if theme == 'monokai' then
  vim.cmd.colorscheme 'monokai-v2'
end
