return {
  {
    "folke/sidekick.nvim",
    dependencies = {
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "neovim/nvim-lspconfig",
    },
    event = "LspAttach",
    keys = {
      {
        "<Leader>ag",
        function() require("sidekick.cli").toggle({ name = "gemini" }) end,
        desc = "Gemini",
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
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      copilot = {
        keys = {
          {
            "<Tab>",
            function()
              if not require("sidekick.nes").have() then
                require("sidekick.nes").update()
                return
              end

              if not require("sidekick").nes_jump_or_apply() then
                return "<Tab>"
              end
            end,
            desc = "Next Edit Suggestion",
            expr = true,
          },
        },
        mason = "copilot-language-server",
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          function() return require("sidekick").nes_jump_or_apply() end,
          "fallback",
        },
      },
    },
  },
}
