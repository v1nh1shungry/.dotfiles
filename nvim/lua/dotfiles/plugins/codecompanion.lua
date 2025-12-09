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
            show_defaults = false,
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
                  -- FIXME: https://github.com/olimorris/codecompanion.nvim/pull/2472
                  --        https://github.com/olimorris/codecompanion.nvim/issues/2477#issuecomment-3613212093
                  choices = function(self)
                    local models = require("codecompanion.adapters.http.openai_compatible").schema.model.choices(self)
                    local ret = {}
                    for _, v in ipairs(models) do
                      ret[v] = {}
                    end
                    return ret
                  end,
                  default = "gemini-claude-opus-4-5-thinking",
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
          adapter = "cli-proxy-api",
          keymaps = {
            send = {
              callback = function(chat)
                vim.cmd("stopinsert")
                require("codecompanion.strategies.chat.keymaps").send.callback(chat)
              end,
            },
          },
          tools = {
            cmd_runner = {
              opts = {
                requires_approval = function(self)
                  local cmd = vim.split(self.args.cmd, " ", { trimempty = true })
                  if #cmd == 0 then
                    return true
                  end

                  if
                    vim.list_contains({
                      "cat",
                      "echo",
                      "head",
                      "ls",
                      "pwd",
                      "tail",
                      "tree",
                      "wc",
                    }, cmd[1])
                  then
                    return false
                  end

                  if
                    cmd[1] == "git"
                    and vim.list_contains({
                      "diff",
                      "log",
                      "show",
                      "status",
                    }, cmd[2])
                  then
                    return false
                  end

                  if cmd[1] == "find" then
                    for i = 2, #cmd do
                      if vim.list_contains({ "-delete", "-exec" }, cmd[i]) then
                        return true
                      end
                    end

                    return false
                  end

                  return true
                end,
              },
            },
            opts = {
              auto_submit_errors = true,
            },
          },
        },
        cmd = {
          adapter = "cli-proxy-api",
        },
        inline = {
          adapter = "cli-proxy-api",
        },
      },
    },
    version = "v17.33.0",
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
          memory = { icon = " ", highlight = "CodeCompanionChatVariable" },
          prompt = { icon = " ", highlight = "CodeCompanionChatTool" },
          symbols = { icon = " ", highlight = "CodeCompanionChatVariable" },
          tool = { icon = " ", highlight = "CodeCompanionChatTool" },
          url = { icon = "󰖟 ", highlight = "CodeCompanionChatVariable" },
          var = { icon = " ", highlight = "CodeCompanionChatVariable" },
        },
      },
    },
  },
}
