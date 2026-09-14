-- smart-splits.nvim configuration for zellij integration
local smart_splits = require('smart-splits')

smart_splits.setup({
  -- ignored filetypes for multiplexer navigation
  ignored_filetypes = {
    'nofile',
    'quickfix',
    'prompt',
  },
  -- ignored buftypes
  ignored_buftypes = {
    'nofile',
    'quickfix',
    'prompt',
  },
  -- default multiplexer integration (auto-detected from $ZELLIJ)
  multiplexer_integration = nil,
})

-- Keymaps for navigation (zellij integration handled by vim-zellij-navigator)
-- smart-splits handles the nvim side: moving between windows and crossing to zellij at edges
vim.keymap.set('n', '<C-h>', function() smart_splits.move_cursor_left() end, { desc = 'Move to left split or zellij pane' })
vim.keymap.set('n', '<C-j>', function() smart_splits.move_cursor_down() end, { desc = 'Move to lower split or zellij pane' })
vim.keymap.set('n', '<C-k>', function() smart_splits.move_cursor_up() end, { desc = 'Move to upper split or zellij pane' })
vim.keymap.set('n', '<C-l>', function() smart_splits.move_cursor_right() end, { desc = 'Move to right split or zellij pane' })

-- Resize splits with Alt+hjkl
vim.keymap.set('n', '<A-h>', function() smart_splits.resize_left() end, { desc = 'Resize split left' })
vim.keymap.set('n', '<A-j>', function() smart_splits.resize_down() end, { desc = 'Resize split down' })
vim.keymap.set('n', '<A-k>', function() smart_splits.resize_up() end, { desc = 'Resize split up' })
vim.keymap.set('n', '<A-l>', function() smart_splits.resize_right() end, { desc = 'Resize split right' })

-- Swap buffers with Ctrl+Alt+hjkl
vim.keymap.set('n', '<C-A-h>', function() smart_splits.swap_buf_left() end, { desc = 'Swap buffer left' })
vim.keymap.set('n', '<C-A-j>', function() smart_splits.swap_buf_down() end, { desc = 'Swap buffer down' })
vim.keymap.set('n', '<C-A-k>', function() smart_splits.swap_buf_up() end, { desc = 'Swap buffer up' })
vim.keymap.set('n', '<C-A-l>', function() smart_splits.swap_buf_right() end, { desc = 'Swap buffer right' })
