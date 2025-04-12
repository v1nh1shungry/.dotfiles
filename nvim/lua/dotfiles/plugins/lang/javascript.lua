vim.lsp.enable("vtsls")

return {
  -- https://www.lazyvim.org/extras/lang/typescript {{{
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "javascript", "jsdoc", "tsx", "typescript" } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "vtsls" } },
  },
  -- }}}
}
