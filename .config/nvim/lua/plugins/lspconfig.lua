return {
  -- Plugin: nvim-lspconfig
  -- URL: https://github.com/neovim/nvim-lspconfig
  -- Description: Quickstart configurations for the Neovim LSP client.
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = false, -- Disable inlay hints
    },
    -- setup = {
    --   jdtls = function()
    --     -- Your nvim-java configuration goes here
    --     require("java").setup({
    --       root_markers = {
    --         "settings.gradle",
    --         "settings.gradle.kts",
    --         "pom.xml",
    --         "build.gradle",
    --         "mvnw",
    --         "gradlew",
    --         "build.gradle",
    --         "build.gradle.kts",
    --         ".git",
    --       },
    --     })
    --   end,
    -- },
  },
}
