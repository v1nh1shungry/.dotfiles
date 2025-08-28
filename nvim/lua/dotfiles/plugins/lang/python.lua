vim.lsp.enable({ "basedpyright", "ruff" })

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python" } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "basedpyright", "ruff" } },
  },
}
