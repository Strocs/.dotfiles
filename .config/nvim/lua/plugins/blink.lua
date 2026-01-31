-- Completion with blink.cmp + Copilot integration
-- Replaces nvim-cmp with blink.cmp for better performance
-- Reference: https://github.com/saghen/blink.cmp

return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },

  version = '1.*',

  opts = {
    keymap = {
      preset = 'default',
      ['<Tab>'] = {
        function(cmp)
          local ok, copilot_suggestion = pcall(require, 'copilot.suggestion')

          if ok and copilot_suggestion.is_visible() then
            if cmp.is_visible() and cmp.get_selected_item_idx() ~= nil then return cmp.accept() end
            copilot_suggestion.accept()
            return true
          end

          if cmp.is_visible() then return cmp.accept() end

          return nil
        end,
        'fallback',
      },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },

    signature = { enabled = true },
  },
}
