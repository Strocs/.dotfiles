require('rip-substitute').setup {}

vim.keymap.set({ 'n', 'x' }, '<leader>rs', function() require('rip-substitute').sub() end, { desc = 'rip substitute' })
