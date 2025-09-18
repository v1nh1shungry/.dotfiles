local mcp_settings_path = vim.fs.joinpath(vim.fn.stdpath("config") --[[@as string]], "mcp.json")

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = "CodeCompanionChat",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    keys = {
      { "<Leader>a", "", desc = "+ai" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "CodeCompanion" },
      { "<Leader>aa", "<Cmd>CodeCompanionChat Add<CR>", desc = "Add Selected to CodeCompanion", mode = "x" },
    },
    opts = {
      adapters = {
        http = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = "GEMINI_API_KEY",
              },
            })
          end,
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
        },
      },
      opts = {
        language = "Chinese",
      },
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    build = "bundled_build.lua",
    cmd = "MCPHub",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      config = mcp_settings_path,
      use_bundled_binary = true,
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
    opts = {
      diff_opts = {
        open_in_new_tab = true,
      },
      terminal = {
        split_width_percentage = 0.4,
      },
      terminal_cmd = "claude --mcp-config=" .. mcp_settings_path,
    },
  },
}
