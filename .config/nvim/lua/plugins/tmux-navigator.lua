return {
  -- Plugin: Vim Tmux Navigator
  -- URL: https://github.com/christoomey/vim-tmux-navigator
  -- Description: Seamless navigation between tmux panes and vim splits
  'christoomey/vim-tmux-navigator',
  event = 'VeryLazy',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
  },
  keys = {
    { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
    { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
    { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
    { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
    { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
  },
}
