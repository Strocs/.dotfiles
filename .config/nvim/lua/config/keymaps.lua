vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
-- vim.keymap.set("n", "-", vim.cmd.Ex)

-- Oil
vim.keymap.set('n', '-', '<CMD>Oil<CR>')

-- Delete all buffers but the current one --
vim.keymap.set('n', '<leader>bq', '<Esc>:%bdelete|edit #|normal`"<Return>')

-- Move selected line / block of text in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep the cursor in the ooriginal position when joining lines
vim.keymap.set('n', 'J', 'mzJ`z')

-- Keep the cursor in the middle when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Keep the cursor in the middle when searching
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Paste without overwriting the default register
vim.keymap.set('x', '<leader>p', [["_dP]])

-- Copy to system clipboard
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')

-- Remplace all occurrences of the word under the cursor
vim.keymap.set('n', '<leader>r', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')

-- Disable key mappings in insert mode
vim.api.nvim_set_keymap('i', '<A-j>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Nop>', { noremap = true, silent = true })

-- Disable key mappings in normal mode
vim.api.nvim_set_keymap('n', '<A-j>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', '<Nop>', { noremap = true, silent = true })

-- Disable key mappings in visual block mode
vim.api.nvim_set_keymap('x', '<A-j>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<A-k>', '<Nop>', { noremap = true, silent = true })

-- Buffers navigation
vim.keymap.set('n', '<S-l>', '<CMD>bnext<CR>')
vim.keymap.set('n', '<S-h>', '<CMD>bprevious<CR>')

-- windows management
vim.keymap.set('n', '<leader>wv', ':vsplit<CR>')
vim.keymap.set('n', '<leader>wh', ':split<CR>')
vim.keymap.set('n', '<leader>wq', ':close<CR>')
vim.keymap.set('n', '<leader>wQ', ':close!<CR>')

-- Resize windows
vim.keymap.set('n', '<C-Right>', '<C-w>>')
vim.keymap.set('n', '<C-Left>', '<C-w><')
vim.keymap.set('n', '<C-Up>', '<C-w>+')
vim.keymap.set('n', '<C-Down>', '<C-w>-')
