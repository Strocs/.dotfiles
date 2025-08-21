return {
  "zbirenbaum/copilot.lua",
  optional = true,
  opts = function()
    require("copilot").setup({
      panel = {
        enabled = true, -- Disable the Copilot panel
      },
      suggestion = {
        enabled = true, -- Enable Copilot suggestions
        auto_trigger = true, -- Automatically trigger suggestions
        debounce = 75, -- Debounce time for suggestions
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false, -- Disable Copilot for all other filetypes
      },
    })
  end,
}
