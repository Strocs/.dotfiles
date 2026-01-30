-- Completion with nvim-cmp
-- Reference: https://github.com/hrsh7th/nvim-cmp

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- LSP completion source
    "hrsh7th/cmp-buffer", -- Buffer completion
    "hrsh7th/cmp-path", -- Path completion
    "hrsh7th/cmp-cmdline", -- Command-line completion
    "L3MON4D3/LuaSnip", -- Snippet engine
  },
  event = "InsertEnter",
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        -- Tab key: Check Copilot first, then cmp
        ["<Tab>"] = cmp.mapping(function(fallback)
          local ok, copilot_suggestion = pcall(require, "copilot.suggestion")
          if ok and copilot_suggestion.is_visible() then
            -- Copilot is visible, accept it
            copilot_suggestion.accept()
          elseif cmp.visible() then
            -- No Copilot, use cmp to select next
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            -- No cmp suggestions, try snippets
            luasnip.expand_or_jump()
          else
            -- Fallback to normal tab behavior
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          local ok, copilot_suggestion = pcall(require, "copilot.suggestion")
          if ok and copilot_suggestion.is_visible() then
            -- Copilot is visible, dismiss and select previous cmp item
            copilot_suggestion.dismiss()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          elseif cmp.visible() then
            -- No Copilot, use cmp to select previous
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            -- No cmp suggestions, try snippets
            luasnip.jump(-1)
          else
            -- Fallback to normal shift-tab behavior
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = function(entry, vim_item)
          -- Add icons for each completion source
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
    })

    -- Command-line completion
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
