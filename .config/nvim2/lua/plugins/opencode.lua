return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for better prompt input, and required to use opencode.nvim's embedded terminal. Otherwise optional.
    { "folke/snacks.nvim", opts = { input = { enabled = true } } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any
      terminal = {
        cmd = "opencode",
        -- This will default to false if `auto_insert` or `start_insert` are set to false.
        -- But it's very confusing if the embedded terminal doesn't exit when `opencode` exits.
        -- So override that.
        auto_close = true,
        win = {
          -- "right" seems like a better default than `snacks.terminal`'s `"float"` default
          position = "right",
          -- Stay in the editor after opening the terminal
          enter = true,
          wo = {
            -- Title is unnecessary - `opencode` TUI has its own footer
            winbar = "",
          },
          bo = {
            -- Make it easier to target for customization, and prevent possibly unintended `"snacks_terminal"` targeting.
            -- e.g. the recommended edgy.nvim integration puts all `"snacks_terminal"` windows at the bottom.
            filetype = "opencode_terminal",
          },
        },
        env = {
          OPENCODE_THEME = "custom-tokyonight",
        },
      },
    }
    vim.keymap.set("n", "<leader>at", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })

    vim.keymap.set("n", "<leader>aA", function()
      require("opencode").ask()
    end, { desc = "Ask opencode" })

    vim.keymap.set("n", "<leader>aa", function()
      require("opencode").ask("@cursor: ")
    end, { desc = "Ask opencode about this" })

    vim.keymap.set("v", "<leader>aa", function()
      require("opencode").ask("@selection: ")
    end, { desc = "Ask opencode about selection" })

    vim.keymap.set("n", "<leader>an", function()
      require("opencode").command("session_new")
    end, { desc = "New opencode session" })

    vim.keymap.set("n", "<leader>ay", function()
      require("opencode").command("messages_copy")
    end, { desc = "Copy last opencode response" })

    vim.keymap.set({ "n", "v" }, "<leader>as", function()
      require("opencode").select()
    end, { desc = "Select opencode prompt" })

    -- Example: keymap for custom prompt
    vim.keymap.set("n", "<leader>ace", function()
      require("opencode").prompt("Explain @cursor and its context")
    end, { desc = "Explain this code" })

    vim.keymap.set("n", "<leader>aci", function()
      require("opencode").prompt("Review @cursor and give improvements suggestions")
    end, { desc = "Improve this code" })
  end,
}
