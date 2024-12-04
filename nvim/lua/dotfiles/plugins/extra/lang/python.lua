return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { basedpyright = {} } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "black" } },
  },
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { python = { "black" } } },
  },
}
