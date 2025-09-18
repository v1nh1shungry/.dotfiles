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
      { "<Leader>aa", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "CodeCompanion" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Add<CR>", desc = "Add Selected to CodeCompanion", mode = "x" },
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
  {
    "coder/claudecode.nvim",
    cmd = { "ClaudeCode" },
    dependencies = "folke/snacks.nvim",
    keys = {
      { "<Leader>ac", "<Cmd>ClaudeCode<CR>", desc = "Claude Code" },
      { "<Leader>ac", "<Cmd>ClaudeCodeSend<CR>", desc = "Add Selected to Claude Code", mode = "x" },
      { "<Leader>aC", "<Cmd>ClaudeCode --continue<CR>", desc = "Resume Claude Code" },
    },
    opts = {},
  },
}
