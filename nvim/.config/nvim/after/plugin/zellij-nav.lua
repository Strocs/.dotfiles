vim.keymap.set('n', '<C-h>', '<Cmd>ZellijNavigateLeft<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<Cmd>ZellijNavigateDown<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<Cmd>ZellijNavigateUp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<Cmd>ZellijNavigateRight<CR>', { noremap = true, silent = true })

require('zellij-nav').setup()

vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    if vim.env.ZELLIJ and vim.fn.executable('zellij') == 1 then
      vim.fn.system({ 'zellij', 'action', 'switch-mode', 'normal' })
    end
  end,
})
