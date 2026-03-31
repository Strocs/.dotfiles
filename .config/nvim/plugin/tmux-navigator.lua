vim.pack.add { 'https://github.com/christoomey/vim-tmux-navigator' }

vim.keymap.set({ 'n', 'i' }, '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>')
vim.keymap.set({ 'n', 'i' }, '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>')
vim.keymap.set({ 'n', 'i' }, '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>')
vim.keymap.set({ 'n', 'i' }, '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>')
vim.keymap.set({ 'n', 'i' }, '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>')
