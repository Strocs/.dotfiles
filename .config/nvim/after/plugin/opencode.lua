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
