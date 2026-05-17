require('harpoon').setup {
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
  },
  settings = {
    save_on_toggle = true,
  },
}

vim.keymap.set('n', '<leader>H', function() require('harpoon'):list():add() end, { desc = 'Harpoon File' })
vim.keymap.set('n', '<leader>h', function()
  local harpoon = require 'harpoon'
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon Quick Menu' })

for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function() require('harpoon'):list():select(i) end, { desc = 'Harpoon to File ' .. i })
end
