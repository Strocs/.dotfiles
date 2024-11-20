return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("noice").setup({
        cmdline = {
          view = "cmdline",
        },
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
