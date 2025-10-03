return {
  {
    "coder/claudecode.nvim",
    cmd = "ClaudeCode",
    dependencies = {
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
    },
    keys = {
      { "<Leader>ac", "<Cmd>ClaudeCode<CR>", desc = "Claude Code" },
      { "<Leader>ac", "<Cmd>ClaudeCodeSend<CR>", desc = "Claude Code", mode = "x" },
    },
    opts = {
      diff_opts = {
        hide_terminal_in_new_tab = true,
        open_in_new_tab = true,
      },
      terminal = {
        snacks_win_opts = {
          keys = {
            hide_n = { "<C-c>", "hide" },
            hide_t = { "<C-q>", "hide", mode = "t" },
            term_normal = { "<C-c>", function() vim.cmd("stopinsert") end, mode = "t" },
          },
          position = "right",
        },
        split_width_percentage = 0.5,
      },
      terminal_cmd = "claude --mcp-config="
        .. vim.fs.joinpath(assert(vim.uv.os_homedir()), ".dotfiles", "claude", "mcp.json"),
    },
  },
  {
    "ravitemer/mcphub.nvim",
    build = "bundled_build.lua",
    cmd = "MCPHub",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      config = vim.fs.joinpath(vim.fn.stdpath("config") --[[@as string]], "mcp.json"),
      ui = {
        window = {
          border = "rounded",
        },
      },
      use_bundled_binary = true,
    },
  },
  {
    "folke/sidekick.nvim",
    dependencies = {
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
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
            stopinsert = { "<C-c>", "stopinsert" },
          },
          split = {
            width = 0.5,
          },
        },
      },
    },
  },
}
