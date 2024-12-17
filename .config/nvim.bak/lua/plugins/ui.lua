return {
  -- messages, cmdline and the popupmenu
  -- Plugin: noice.nvim
  -- URL: https://github.com/folke/noice.nvim
  -- Description: A Neovim plugin for enhancing the command-line UI.
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        cmdline = {
          view = "cmdline", -- Use the cmdline view for the command-line
        },
        presets = {
          bottom_search = true, -- Enable bottom search view
          command_palette = true, -- Enable command palette view
          lsp_doc_border = true, -- Enable LSP documentation border
        },
        -- Uncomment the following lines to customize the cmdline popup view
        -- views = {
        --   cmdline_popup = {
        --     filter_options = {},
        --     win_options = {
        --       winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        --     },
        --   },
        -- },
      })
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    opts = {
      options = {
        -- globalstatus = false,
        theme = "sonokai",
        icons_enabled = true,
      },
      sections = {
        lualine_z = {},
        lualine_a = {
          {
            "mode",
            icon = "🧔",
          },
        },
      },
    },
  },

  -- Plugin: mini.nvim
  -- URL: https://github.com/echasnovski/mini.nvim
  -- Description: A collection of minimal, fast, and modular Lua plugins for Neovim.
  {
    "echasnovski/mini.nvim",
    version = false, -- Use the latest version
    config = function()
      require("mini.animate").setup({
        resize = {
          enable = false, -- Disable resize animations
        },
        open = {
          enable = false, -- Disable open animations
        },
        close = {
          enable = false, -- Disable close animations
        },
        scroll = {
          enable = false, -- Disable scroll animations
        },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
     .M"""bgd mm                                                                  
     ,MI    "Y MM                                                                 
     `MMb.   mmMMmm `7Mb,od8 ,pW"Wq.   ,p6"bo  ,pP"Ybd                            
       `YMMNq. MM     MM' "'6W'   `Wb 6M'  OO  8I   `"    ,,                      
     .     `MM MM     MM    8M     M8 8M       `YMMMa.  `7MM                      
     Mb     dM MM     MM    YA.   ,A9 YM.    , L.   I8    MM                      
     P"Ybmmd"  `Mbmo.JMML.   `Ybmd9'   YMbmd'  M9mmmP,M""bMM  .gP"Ya `7M'   `MF'  
                                                   ,AP    MM ,M'   Yb  VA   ,V    
                                                   8MI    MM 8M""""""   VA ,V     
                                                   `Mb    MM YM.    ,    VVV      
                                                    `Wbmd"MML.`Mbmmd'     W       
          ]],
        },
      },
    },
  },
}
