require('zellij-nav').setup()

vim.keymap.set('n', '<c-h>', '<CMD>ZellijNavigateLeft<cr>')
vim.keymap.set('n', '<c-j>', '<CMD>ZellijNavigateDown<cr>')
vim.keymap.set('n', '<c-k>', '<CMD>ZellijNavigateUp<cr>')
vim.keymap.set('n', '<c-l>', '<CMD>ZellijNavigateRight<cr>')

vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    if vim.env.ZELLIJ and vim.fn.executable('zellij') == 1 then
      vim.fn.system({ 'zellij', 'action', 'switch-mode', 'normal' })
    end
  end,
})
