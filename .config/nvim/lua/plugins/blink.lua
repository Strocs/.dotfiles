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
        function(cmp)
          -- Priority 1: Check if there's an active selection in the completion list
          local has_completion_selection = cmp.get_selected_item() ~= nil

          if has_completion_selection then
            -- There's an active completion selection, accept it
            return cmp.accept()
          end

          -- Priority 2: Check if Copilot suggestion is visible and accept it
          local ok, copilot_suggestion = pcall(require, 'copilot.suggestion')
          if ok and copilot_suggestion.is_visible() then
            copilot_suggestion.accept()
            return true
          end

          -- No completion or copilot suggestion, return nil to continue chain
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
