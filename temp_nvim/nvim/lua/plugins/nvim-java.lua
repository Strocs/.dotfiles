return {
  "nvim-java/nvim-java",
  lazy = 1000,

  config = function()
    require("java").setup()
    require("lspconfig").jdtls.setup()
  end,
}
