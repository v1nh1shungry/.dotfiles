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
      "folke/snacks.nvim",
      "ravitemer/codecompanion-history.nvim",
      {
        "ravitemer/mcphub.nvim",
        build = "bundled_build.lua",
        cmd = "MCPHub",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {
          auto_approve = true,
          auto_toggle_mcp_servers = false,
          config = vim.fs.joinpath(vim.fn.stdpath("config"), "mcphub.json"),
          use_bundled_binary = true,
        },
      },
    },
    keys = {
      { "<Leader>aa", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "CodeCompanion" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Add<CR>", desc = "CodeCompanion", mode = "x" },
      { "<Leader>aA", "<Cmd>CodeCompanionHistory<CR>", desc = "CodeCompanion (Resume)" },
    },
    opts = {
      adapters = {
        acp = {
          opts = {
            show_presets = false,
          },
        },
        http = {
          ["cli-proxy-api"] = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                api_key = "CLI_PROXY_API_KEY",
                url = "CLI_PROXY_API_URL",
              },
              formatted_name = "CLI Proxy API",
              name = "cli-proxy-api",
              schema = {
                model = {
                  default = "gemini-claude-opus-4-5-thinking",
                },
              },
            })
          end,
          opts = {
            show_model_choices = true,
            show_presets = false,
          },
        },
      },
      extensions = {
        history = {
          opts = {
            expiration_days = 7,
            summary = {
              generation_opts = {
                adapter = "cli-proxy-api",
                model = "qwen3-coder-flash",
              },
            },
            title_generation_opts = {
              adapter = "cli-proxy-api",
              model = "qwen3-coder-flash",
            },
          },
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = false,
            show_server_tools_in_chat = false,
          },
        },
      },
      interactions = {
        backgroud = {
          adapter = {
            model = "qwen3-coder-flash",
            name = "cli-proxy-api",
          },
        },
        chat = {
          adapter = "cli-proxy-api",
          keymaps = {
            send = {
              callback = function(chat)
                vim.cmd("stopinsert")
                require("codecompanion.interactions.chat.keymaps").send.callback(chat)
              end,
            },
          },
          -- TODO: treat cmd_runner's approval carefully.
        },
        cmd = {
          adapter = "cli-proxy-api",
        },
        inline = {
          adapter = "cli-proxy-api",
        },
      },
      opts = {
        language = "Chinese",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "codecompanion",
    opts = {
      file_types = { "codecompanion" },
      html = {
        tag = {
          buf = { icon = " ", highlight = "CodeCompanionChatVariable" },
          file = { icon = " ", highlight = "CodeCompanionChatVariable" },
          group = { icon = " ", highlight = "CodeCompanionChatToolGroup" },
          help = { icon = "󰘥 ", highlight = "CodeCompanionChatVariable" },
          image = { icon = " ", highlight = "CodeCompanionChatVariable" },
          prompt = { icon = " ", highlight = "CodeCompanionChatTool" },
          rules = { icon = " ", highlight = "CodeCompanionChatVariable" },
          symbols = { icon = " ", highlight = "CodeCompanionChatVariable" },
          tool = { icon = " ", highlight = "CodeCompanionChatTool" },
          url = { icon = "󰖟 ", highlight = "CodeCompanionChatVariable" },
          var = { icon = " ", highlight = "CodeCompanionChatVariable" },
        },
      },
    },
  },
}
