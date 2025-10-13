return {
  {
    "folke/sidekick.nvim",
    dependencies = {
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = "LspAttach",
    keys = {
      {
        "<Leader>ag",
        function() require("sidekick.cli").toggle({ name = "gemini" }) end,
        desc = "Gemini",
        mode = { "n", "x" },
      },
      {
        "<Leader>aq",
        function() require("sidekick.cli").toggle({ name = "qwen" }) end,
        desc = "Qwen",
        mode = { "n", "x" },
      },
    },
    opts = {
      cli = {
        win = {
          keys = {
            hide_n = { "<C-c>", "hide", mode = "n" },
            prompt = { "<M-p>", "prompt" },
            stopinsert = { "<C-c>", "stopinsert" },
          },
          split = {
            width = 0.5,
          },
        },
      },
      nes = {
        enabled = false,
      },
    },
  },
}
