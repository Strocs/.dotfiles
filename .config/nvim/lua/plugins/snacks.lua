return {
  'folke/snacks.nvim',
  priority = 1000,
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ['<C-down>'] = { 'preview_scroll_down', mode = { 'i', 'n' }, desc = 'Preview down (alt)' },
            ['<C-up>'] = { 'preview_scroll_up', mode = { 'i', 'n' }, desc = 'Preview up (alt)' },
          },
        },
      },
    },
  },
  keys = {
    -- === BUSQUEDAS PRINCIPALES ===
    -- <leader><leader> = Buscar archivos en el proyecto
    { '<leader><leader>', function() Snacks.picker.files() end, desc = 'Find Files' },

    -- <leader>sw = Buscar la palabra bajo el cursor (word match)
    -- ⚠️ Note: Snacks usa grep_word por defecto, igual a grep_string word_match=true
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Search Word' },

    -- <leader>fg = Búsqueda live de texto en todos los archivos
    { '<leader>fg', function() Snacks.picker.grep() end, desc = 'Live Grep' },

    -- <leader>fb = Listar buffers abiertos
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },

    -- <leader>fh = Buscar en la documentación de Neovim
    { '<leader>fh', function() Snacks.picker.help() end, desc = 'Help Tags' },

    -- === BÚSQUEDAS SECUNDARIAS ===
    -- <leader>sd = Buscar definitions con Snacks (útil cuando hay múltiples results)
    { '<leader>sd', function() Snacks.picker.lsp_definitions() end, desc = 'Search Definitions (Snacks)' },

    -- <leader>gr = Listar todas las referencias del símbolo bajo el cursor
    { 'gr', function() Snacks.picker.lsp_references() end, desc = 'References (Snacks)' },

    -- <leader>sb = Buscar texto dentro del buffer actual
    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Search in Buffer' },

    -- <leader>sR = Reanudar la última búsqueda de Snacks
    { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume Last Search' },
  },
}
