---@type snacks.win.Config|{}
local snacks_win_opts = {
  position = "right",
  width = 0.5,
  keys = {
    hide = { "<C-c>", "hide", desc = "Hide" },
    term_normal = { "<C-c>", function() vim.cmd("stopinsert") end, mode = "t", desc = "Enter Normal Mode" },
  },
}

return {
  {
    "coder/claudecode.nvim",
    cmd = { "ClaudeCode" },
    dependencies = {
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
    },
    keys = {
      { "<Leader>ac", "<Cmd>ClaudeCode --continue<CR>", desc = "Claude Code (Resume)" },
      { "<Leader>ac", "<Cmd>ClaudeCodeSend<CR>", desc = "Add Selected to Claude Code", mode = "x" },
      { "<Leader>aC", "<Cmd>ClaudeCode<CR>", desc = "Claude Code (New)" },
    },
    opts = {
      diff_opts = {
        hide_terminal_in_new_tab = true,
        open_in_new_tab = true,
      },
      terminal = {
        snacks_win_opts = snacks_win_opts,
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
    keys = {
      {
        "<leader>ax",
        function() Snacks.terminal.toggle({ "codex", "resume" }, { win = snacks_win_opts }) end,
        desc = "Codex",
      },
      {
        "<leader>ag",
        function() Snacks.terminal.toggle("gemini", { win = snacks_win_opts }) end,
        desc = "Gemini",
      },
    },
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
}
