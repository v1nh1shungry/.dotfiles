return {
  {
    "olimorris/codecompanion.nvim",
    cmd = "CodeCompanionChat",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<Leader>a", "", desc = "+ai" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "Chat" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Add<CR>", mode = "x", desc = "Add Selected to Chat" },
      { "<Leader>a/", "<Cmd>CodeCompanionActions<CR>", desc = "Actions" },
    },
    opts = {
      opts = {
        language = "Chinese",
      },
      strategies = {
        chat = {
          adapter = "gemini_cli",
        },
      },
    },
  },
}
