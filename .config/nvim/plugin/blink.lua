vim.pack.add {
  'https://github.com/rafamadriz/friendly-snippets',
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.1' },
}

require('blink.cmp').setup {
  completion = {
    accept = {},
    list = {
      selection = {
        preselect = false,
      },
    },
  },
  keymap = {
    preset = 'default',
    ['<Tab>'] = {
      function(cmp)
        local has_completion_selection = cmp.get_selected_item() ~= nil

        if has_completion_selection then
          return cmp.accept()
        end

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
}
