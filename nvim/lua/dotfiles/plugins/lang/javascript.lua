vim.lsp.enable("ts_ls")

return {
  -- https://www.lazyvim.org/extras/lang/typescript {{{
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "javascript", "jsdoc", "typescript" } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "typescript-language-server" } },
  },
  -- }}}
}
