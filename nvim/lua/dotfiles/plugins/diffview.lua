return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    config = function()
      local actions = require("diffview.actions")

      local opts = {
        enhanced_diff_hl = true,
        view = {
          default = { disable_diagnostics = true, winbar_info = true },
          merge_tool = { layout = "diff3_mixed" },
          file_history = { disable_diagnostics = true, winbar_info = true },
        },
        keymaps = {
          file_history_panel = {
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle File Panel" } },
            ["<leader>b"] = false,
          },
          view = {
            ["<leader>co"] = false,
            ["<leader>ct"] = false,
            ["<leader>cb"] = false,
            ["<leader>ca"] = false,
            { "n", "<Leader>gxo", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
            { "n", "<Leader>gxt", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
            { "n", "<Leader>gxb", actions.conflict_choose("base"), { desc = "Choose BASE" } },
            { "n", "<Leader>gxa", actions.conflict_choose("all"), { desc = "Choose All" } },
          },
          file_panel = {
            ["<leader>cO"] = false,
            ["<leader>cT"] = false,
            ["<leader>cB"] = false,
            ["<leader>cA"] = false,
            { "n", "<Leader>gxO", actions.conflict_choose_all("ours"), { desc = "Choose OURS (File)" } },
            { "n", "<Leader>gxT", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS (File)" } },
            { "n", "<Leader>gxB", actions.conflict_choose_all("base"), { desc = "Choose BASE (File)" } },
            { "n", "<Leader>gxA", actions.conflict_choose_all("all"), { desc = "Choose All (File)" } },
          },
        },
        hooks = { view_opened = function() require("diffview.actions").toggle_files() end },
      }

      opts.keymaps.file_panel = vim.tbl_deep_extend("force", opts.keymaps.file_panel, opts.keymaps.file_history_panel)
      opts.keymaps.view = vim.tbl_deep_extend("force", opts.keymaps.file_panel, opts.keymaps.view)

      require("diffview").setup(opts)
    end,
    keys = {
      { "<Leader>gD", "<Cmd>DiffviewOpen<CR>", desc = "Diff Pane" },
      {
        "<Leader>gH",
        function() vim.cmd("DiffviewFileHistory" .. (vim.bo.buftype == "" and " %" or "")) end,
        desc = "History",
      },
    },
  },
}
