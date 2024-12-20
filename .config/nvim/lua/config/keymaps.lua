-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Delete all buffers but the current one --
vim.keymap.set(
  "n",
  "<leader>bq",
  '<Esc>:%bdelete|edit #|normal`"<Return>',
  { desc = "Delete other buffers but the current one" }
)

-- -- Tmux Navigation --
-- local nvim_tmux_nav = require("nvim-tmux-navigation")
--
-- vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
-- vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
-- vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
-- vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
-- vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
-- vim.keymap.set("n", "<C-n>", nvim_tmux_nav.NvimTmuxNavigateNext)
