-- vim.loader enable MUST be the first line (provides ~30% startup speedup)
vim.loader.enable()

require 'config.options'
require 'config.keymaps'

-- Preload mini.icons mock for nvim-web-devicons compatibility
-- (runs before any plugin file that requires nvim-web-devicons)
package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

-- PackChanged hooks MUST be defined BEFORE any vim.pack.add() call
-- (so install hooks work on first bootstrapping from lockfile)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    -- treesitter: update parsers on plugin update
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

-- NOTE: vim.pack.add() is called in each plugin/ file (multi-file approach).
-- The plugin/ directory is sourced alphabetically by Neovim at startup,
-- which installs + loads all plugins in the correct dependency order.
