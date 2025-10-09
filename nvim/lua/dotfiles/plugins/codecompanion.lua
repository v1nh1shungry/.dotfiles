return {
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "lalitmee/codecompanion-spinners.nvim",
    },
    keys = {
      { "<Leader>aa", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "CodeCompanion" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Add<CR>", desc = "Add Selected to CodeCompanion", mode = "x" },
    },
    opts = {
      adapters = {
        http = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = "CLI_PROXY_API_KEY",
              },
              url = "http://localhost:8317/v1/chat/completions",
            })
          end,
        },
      },
      display = {
        chat = {
          window = {
            width = 0.5,
          },
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
        },
        spinner = {},
      },
      opts = {
        language = "Chinese",
      },
      strategies = {
        chat = {
          adapter = "gemini",
        },
        cmd = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
    },
  },
}
