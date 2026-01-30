return {
  -- Plugin: lualine.nvim
  -- URL: https://github.com/nvim-lualine/lualine.nvim
  -- Description: A blazing fast and easy to configure Neovim statusline plugin.
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local auto = require("lualine.themes.auto")
    local lualine_modes = { "insert", "normal", "visual", "replace", "command", "terminal", "inactive" }
    for _, field in ipairs(lualine_modes) do
      if auto[field] and auto[field].c then
        auto[field].c.bg = nil -- inherit from StatusLine
      end
    end
    opts.options.theme = auto
    opts.sections.lualine_z = {}

    -- Set StatusLine bg transparent
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
  end,
}
