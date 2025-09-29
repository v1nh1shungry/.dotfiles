return {
  {
    "coder/claudecode.nvim",
    cmd = { "ClaudeCode" },
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
            hide = { "<C-c>", "hide", desc = "Hide" },
            term_normal = { "<C-c>", function() vim.cmd("stopinsert") end, mode = "t", desc = "Enter Normal Mode" },
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
    },
    keys = {
      {
        "<Leader>ax",
        function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end,
        desc = "Codex",
        mode = { "n", "x" },
      },
    },
    opts = {
      cli = {
        win = {
          keys = {
            hide = { "<C-c>", "hide", desc = "Hide" },
            term_normal = { "<C-c>", function() vim.cmd("stopinsert") end, mode = "t", desc = "Enter Normal Mode" },
          },
          width = 0.5,
        },
      },
    },
  },
}
