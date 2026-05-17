require('copilot').setup {
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = false,
      next = '<M-]>',
      prev = '<M-[>',
    },
  },
  panel = { enabled = false },
  filetypes = {
    markdown = true,
    help = true,
  },
}
