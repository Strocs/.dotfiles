return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "ravitemer/mcphub.nvim",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Toggle [C]hat" },
      { "<leader>an", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "AI [N]ew Chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI [A]ction" },
      { "ga", "<cmd>CodeCompanionChat Add<CR>", mode = { "v" }, desc = "AI [A]dd to Chat" },
      -- prompts
      { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = { "v" }, desc = "AI [E]xplain" },
    },
    opts = {
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- MCP Tools
            make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true, -- Show tool results directly in chat buffer
            format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            -- MCP Resources
            make_vars = true, -- Convert MCP resources to #variables for prompts
            -- MCP Prompts
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
      },
      -- adapters = {
      --   copilot = function()
      --     return require("codecompanion.adapters").extend("copilot", {
      --       schema = {
      --         model = {
      --           default = "gpt-4.1",
      --         },
      --       },
      --     })
      --   end,
      --   gemini = function()
      --     return require("codecompanion.adapters").extend("gemini", {
      --       env = {
      --         api_key = "cmd:echo ${}",
      --       },
      --     })
      --   end,
      -- },
      -- strategies = {
      --   chat = {
      --     adapter = {
      --       name = "copilot",
      --       model = "gpt-4.1",
      --     },
      --     roles = {
      --       user = "strocs",
      --     },
      --   },
      --   inline = {
      --     adapter = {
      --       name = "copilot",
      --       model = "gpt-4.1",
      --     },
      --   },
      -- },
    },
  },
}
