vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/sudo-tee/opencode.nvim',
}

require('render-markdown').setup {
  anti_conceal = { enabled = false },
  file_types = { 'markdown', 'opencode_output' },
}

require('opencode').setup {
  keymap = {
    input_window = {
      ['<esc>'] = false,
    },
    output_window = {
      ['<esc>'] = false,
    },
  },
}
