return {
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionHistory",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    keys = {
      { "<Leader>aa", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "Code Companion" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Add<CR>", desc = "Code Companion", mode = "x" },
    },
    opts = {
      adapters = {
        acp = {
          opts = {
            show_defaults = false,
          },
        },
        http = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = "CLI_PROXY_API_KEY",
              },
              url = "http://localhost:8317/v1/chat/completions",
            })
          end,
          opts = {
            show_defaults = false,
            show_model_choices = true,
          },
        },
      },
      display = {
        chat = {
          window = {
            width = 0.5,
          },
        },
        diff = {
          provider_opts = {
            inline = {
              layout = "buffer",
            },
          },
        },
      },
      extensions = {
        history = {
          opts = {
            delete_on_clearing_chat = true,
            expiration_days = 7,
            summary = {
              generation_opts = {
                adapter = "gemini",
                model = "gemini-2.5-flash",
              },
            },
            title_generation_opts = {
              adapter = "gemini",
              model = "gemini-2.5-flash-lite",
            },
          },
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
        },
        spinner = {},
      },
      memory = {
        opts = {
          chat = {
            enabled = true,
          },
        },
      },
      opts = {
        language = "Chinese",
      },
      strategies = {
        chat = {
          adapter = {
            model = "gemini-2.5-pro",
            name = "gemini",
          },
          tools = {
            opts = {
              auto_submit_errors = true,
            },
          },
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
