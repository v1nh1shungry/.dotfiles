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
          modelscope = function()
            local openai = require("codecompanion.adapters.http.openai")

            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                api_key = "MODELSCOPE_API_KEY",
                url = "https://api-inference.modelscope.cn",
              },
              formatted_name = "Modelscope",
              name = "modelscope",
              handlers = {
                form_parameters = function(self, params, messages)
                  if params.model:find("Qwen3") and not params.stream then
                    params.enable_thinking = false
                  end
                  return openai.handlers.form_parameters(self, params, messages)
                end,
              },
              schema = {
                model = {
                  choices = {
                    "ZhipuAI/GLM-4.6",
                    "ZhipuAI/GLM-4.5",
                  },
                  default = "ZhipuAI/GLM-4.6",
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
                adapter = "modelscope",
                model = "Qwen/Qwen3-8B",
              },
            },
            title_generation_opts = {
              adapter = "modelscope",
              model = "Qwen/Qwen3-8B",
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
          adapter = "modelscope",
          roles = {
            llm = function(adapter)
              return ("%s | %s"):format(
                adapter.model.formatted_name or adapter.model.name,
                adapter.formatted_name or adapter.name
              )
            end,
          },
          tools = {
            opts = {
              auto_submit_errors = true,
            },
          },
        },
        cmd = {
          adapter = "modelscope",
        },
        inline = {
          adapter = "modelscope",
        },
      },
    },
  },
}
