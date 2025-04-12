vim.lsp.enable({ "basedpyright", "ruff" })

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python", "rst" } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "basedpyright", "ruff" } },
  },
}
