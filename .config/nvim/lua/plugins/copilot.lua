return {
  "zbirenbaum/copilot.lua",
  opts = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = true,
        debounde = 75,
      },
    })
  end,
}
