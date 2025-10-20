return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "javascript",
        "jsdoc",
        "typescript",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      vtsls = {},
    },
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "html",
    opts = {},
  },
}
