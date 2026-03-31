vim.pack.add { 'https://github.com/chrisgrieser/nvim-rip-substitute' }

require('rip-substitute').setup {}

vim.keymap.set({ 'n', 'x' }, '<leader>rs', function() require('rip-substitute').sub() end, { desc = 'rip substitute' })
