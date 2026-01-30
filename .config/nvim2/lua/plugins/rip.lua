return {
  -- Plugin: nvim-rip-substitute
  -- URL: https://github.com/chrisgrieser/nvim-rip-substitute
  -- Description: A Neovim plugin for performing substitutions with ripgrep.
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
  keys = {
    {
      "<leader>fs",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = " rip substitute",
    },
  },
}
