return {
  -- Plugin: snacks.nvim
  -- URL: https://github.com/folke/snacks.nvim
  -- Description: 🍿 A collection of small QoL plugins for Neovim
  "snacks.nvim",
  ---@type snacks.Config
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
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
