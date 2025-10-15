return {
  {
    "ravitemer/mcphub.nvim",
    build = "bundled_build.lua",
    cmd = "MCPHub",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      auto_approve = true,
      config = vim.fs.joinpath(vim.fn.stdpath("config") --[[@as string]], "mcphub.json"),
      ui = {
        window = {
          border = "rounded",
        },
      },
      use_bundled_binary = true,
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = "ravitemer/mcphub.nvim",
    opts = {
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
        },
      },
    },
  },
}
