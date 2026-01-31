return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  dependencies = {
    { 'nvim-mini/mini.icons' },
  },
  opts = {
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-u>'] = { 'actions.select', opts = { horizontal = true } }, -- Modifed: Avoid collision with tmux navigation
      ['<C-d>'] = { 'actions.select', opts = { vertical = true } }, -- Modifed: Avoid collision with save keymap
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['<C-f>'] = 'actions.refresh', -- Modified: Avoid collision with tmux navigator
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
    use_default_keymaps = false,
    columns = {
      'icon',
    },
  },
}
