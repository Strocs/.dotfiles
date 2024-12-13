return {
  "nvim-java/nvim-java",
  config = false,
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          -- Your JDTLS configuration goes here
          -- jdtls = {
          --   settings = {
          --     java = {
          --       configuration = {
          --         runtimes = {
          --           {
          --             name = "JavaSE-21",
          --             path = "/usr/lib/jvm/jdk-21.0.5/",
          --             default = true,
          --           },
          --         },
          --       },
          --     },
          --   },
          -- },
        },
        setup = {
          jdtls = function()
            -- Your nvim-java configuration goes here
            require("java").setup({
              root_markers = {
                "settings.gradle",
                "settings.gradle.kts",
                "pom.xml",
                "build.gradle",
                "mvnw",
                "gradlew",
                "build.gradle",
                "build.gradle.kts",
              },
            })
          end,
        },
      },
    },
  },
}
