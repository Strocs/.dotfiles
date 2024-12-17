return {
  -- Plugin: mason.nvim
  -- URL: https://github.com/williamboman/mason.nvim
  -- Description: Portable package manager for Neovim. Install and manage LSP servers, DAP servers, linters, and formatters.
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "vtsls",
      "astro-language-server",
      "tailwindcss-language-server",
    },
  },
}
