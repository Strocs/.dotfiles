return {
  'folke/snacks.nvim',
  priority = 1000,
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ['<A-j>'] = { 'preview_scroll_down', mode = { 'i', 'n' }, desc = 'Preview down (alt)' },
            ['<A-k>'] = { 'preview_scroll_up', mode = { 'i', 'n' }, desc = 'Preview up (alt)' },
          },
        },
      },
    },
  },
  keys = {
    -- Buscar archivos en el proyecto
    { '<leader><leader>', function() Snacks.picker.files() end, desc = 'Find Files' },

    -- Buscar la palabra bajo el cursor (word match)
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Search Word' },

    --Búsqueda live de texto en todos los archivos
    { '<leader>/', function() Snacks.picker.grep() end, desc = 'Live Grep' },

    -- Listar buffers abiertos
    { '<leader>sb', function() Snacks.picker.buffers() end, desc = 'Buffers' },

    -- Buscar en la documentación de Neovim
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Tags' },

    -- Buscar definitions con Snacks (útil cuando hay múltiples results)
    { '<leader>sd', function() Snacks.picker.lsp_definitions() end, desc = 'Search Definitions (Snacks)' },

    -- Listar todas las referencias del símbolo bajo el cursor
    { 'gr', function() Snacks.picker.lsp_references() end, desc = 'References (Snacks)' },

    -- Buscar texto dentro del buffer actual
    { '<leader>sl', function() Snacks.picker.lines() end, desc = 'Search in Buffer' },

    -- Reanudar la última búsqueda de Snacks
    { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume Last Search' },
  },
}
