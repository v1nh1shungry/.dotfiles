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
      { "<Leader>aC", "<Cmd>ClaudeCode --resume<CR>", desc = "Claude Code (Resume)" },
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
        },
        split_width_percentage = 0.5,
      },
      terminal_cmd = "claude --mcp-config="
        .. vim.fs.joinpath(assert(vim.uv.os_homedir()), ".dotfiles", "claude", "mcp.json"),
    },
  },
}
