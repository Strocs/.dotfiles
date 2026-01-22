local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

configs.setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    custom_captures = {
      ["keyword"] = "Keyword",
      ["function"] = "Function",
      ["method"] = "Function",
      ["variable"] = "Identifier",
    },
  },
})

vim.api.nvim_set_hl(0, "@keyword", { link = "Keyword" })
vim.api.nvim_set_hl(0, "@function", { link = "Function" })
vim.api.nvim_set_hl(0, "@method", { link = "Function" })
