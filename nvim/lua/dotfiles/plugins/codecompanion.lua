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
        lsp = {},
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
          tools = {
            ["cmd_runner"] = {
              opts = {
                ---@param self CodeCompanion.Tools.Tool
                require_approval_before = function(self)
                  ---@type TSTree?
                  local root = vim.F.npcall(
                    function() return vim.treesitter.get_string_parser(self.args.cmd, "bash"):parse()[1]:root() end
                  )
                  if not root then
                    return true
                  end

                  local query = vim.treesitter.query.parse(
                    "bash",
                    [[
                  (command
                    name: (command_name) @_git
                    argument: (word) @git_subcmd
                    (#eq? @_git "git")
                    (#set! "priority" 200))

                  (command
                    name: (command_name) @cmd
                    (#not-eq? @cmd "git"))

                  (redirected_statement) @redirect
                  ]]
                  )

                  local safe_cmd = {
                    ["cat"] = true,
                    ["echo"] = true,
                    ["grep"] = true,
                    ["head"] = true,
                    ["ls"] = true,
                    ["pwd"] = true,
                    ["tail"] = true,
                    ["tree"] = true,
                    ["wc"] = true,
                  }

                  local safe_git_subcmd = {
                    ["diff"] = true,
                    ["log"] = true,
                    ["show"] = true,
                    ["status"] = true,
                  }

                  for id, node in query:iter_captures(root, self.args.cmd) do
                    if query.captures[id] == "redirect" then
                      return true
                    end

                    local text = vim.treesitter.get_node_text(node, self.args.cmd)
                    if query.captures[id] == "git_subcmd" and not safe_git_subcmd[text] then
                      return true
                    end

                    if query.captures[id] == "cmd" and not safe_cmd[text] then
                      return true
                    end
                  end

                  return false
                end,
              },
            },
            ["web_search"] = {
              enabled = false,
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
