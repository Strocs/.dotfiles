return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },

  version = '1.*',

  opts = {
    completion = {
      list = {
        selection = {
          preselect = false, -- Disable preselecting the first item in the completion list
        },
      },
    },
    keymap = {
      preset = 'default',
      ['<Tab>'] = {
        function()
          local ok, copilot_suggestion = pcall(require, 'copilot.suggestion')

          if ok and copilot_suggestion.is_visible() then
            copilot_suggestion.accept()
            return true
          end

          return nil
        end,
        'snippet_forward',
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
