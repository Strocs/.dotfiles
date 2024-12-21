return {
  "nvim-java/nvim-java",
  config = false,
  dependencies = {
    {
      "williamboman/mason.nvim",
      opts = {
        registries = {
          "github:nvim-java/mason-registry",
          "github:mason-org/mason-registry",
        },
      },
    },
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          -- Your JDTLS configuration goes here
          jdtls = {
            -- settings = {
            --   java = {
            --     configuration = {
            --       runtimes = {
            --         {
            --           name = "openjdk-23",
            --           path = "/home/linuxbrew/.linuxbrew/opt/openjdk/23.0.1",
            --           default = true,
            --         },
            --       },
            --     },
            --   },
            -- },
          },
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
