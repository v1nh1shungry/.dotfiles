return {
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionHistory",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
      "franco-ruggeri/codecompanion-spinner.nvim",
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
          bigmodel = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                api_key = "BIGMODEL_API_KEY",
                chat_url = "/chat/completions",
                url = "https://open.bigmodel.cn/api/coding/paas/v4",
              },
              formatted_name = "BigModel",
              name = "bigmodel",
              schema = {
                model = {
                  choices = {
                    "glm-4.5-air",
                    "glm-4.6",
                  },
                  default = "glm-4.6",
                },
              },
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
          show_settings = true,
          window = {
            opts = {
              conceallevel = 2,
            },
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
                adapter = "bigmodel",
                model = "glm-4.5-air",
              },
            },
            title_generation_opts = {
              adapter = "bigmodel",
              model = "glm-4.5-air",
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
          adapter = "bigmodel",
          keymaps = {
            send = {
              callback = function(chat)
                vim.cmd("stopinsert")
                require("codecompanion.strategies.chat.keymaps").send.callback(chat)
              end,
            },
          },
          tools = {
            opts = {
              auto_submit_errors = true,
            },
          },
        },
        cmd = {
          adapter = "bigmodel",
        },
        inline = {
          adapter = "bigmodel",
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "codecompanion",
    opts = {
      code = {
        position = "right",
      },
      file_types = { "codecompanion" },
      html = {
        tag = {
          buf = { icon = " ", highlight = "CodeCompanionChatVariable" },
          file = { icon = " ", highlight = "CodeCompanionChatVariable" },
          help = { icon = "󰘥 ", highlight = "CodeCompanionChatVariable" },
          image = { icon = " ", highlight = "CodeCompanionChatVariable" },
          symbols = { icon = " ", highlight = "CodeCompanionChatVariable" },
          url = { icon = "󰖟 ", highlight = "CodeCompanionChatVariable" },
          var = { icon = " ", highlight = "CodeCompanionChatVariable" },
          tool = { icon = " ", highlight = "CodeCompanionChatTool" },
          prompt = { icon = " ", highlight = "CodeCompanionChatTool" },
          group = { icon = " ", highlight = "CodeCompanionChatToolGroup" },
        },
      },
      latex = {
        enabled = false,
      },
      sign = {
        enabled = false,
      },
    },
  },
}
