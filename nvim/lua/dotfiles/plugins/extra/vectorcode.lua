return {
  {
    "Davidyz/VectorCode",
    build = "uv tool upgrade vectorcode",
    cmd = "VectorCode",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      async_backend = "lsp",
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = "Davidyz/VectorCode",
    opts = {
      extensions = {
        vectorcode = {},
      },
    },
  },
}
