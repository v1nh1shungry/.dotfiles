return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<Leader>gD", "<Cmd>DiffviewOpen<CR>", desc = "Diff Pane" },
      {
        "<Leader>gH",
        function() vim.cmd("DiffviewFileHistory" .. (vim.bo.buftype == "" and " %" or "")) end,
        desc = "History",
      },
    },
    opts = function()
      local actions = require("diffview.actions")

      return {
        enhanced_diff_hl = true,
        hooks = {
          view_opened = function() require("diffview.actions").toggle_files() end,
        },
        keymaps = {
          file_history_panel = {
            ["<leader>b"] = false,
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle File Panel" } },
          },
          file_panel = {
            ["<leader>b"] = false,
            ["<leader>cO"] = false,
            ["<leader>cT"] = false,
            ["<leader>cB"] = false,
            ["<leader>cA"] = false,
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle File Panel" } },
            { "n", "<Leader>gxO", actions.conflict_choose_all("ours"), { desc = "Choose OURS (File)" } },
            { "n", "<Leader>gxT", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS (File)" } },
            { "n", "<Leader>gxB", actions.conflict_choose_all("base"), { desc = "Choose BASE (File)" } },
            { "n", "<Leader>gxA", actions.conflict_choose_all("all"), { desc = "Choose All (File)" } },
          },
          view = {
            ["<leader>b"] = false,
            ["<leader>co"] = false,
            ["<leader>ct"] = false,
            ["<leader>cb"] = false,
            ["<leader>ca"] = false,
            ["<leader>cO"] = false,
            ["<leader>cT"] = false,
            ["<leader>cB"] = false,
            ["<leader>cA"] = false,
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle File Panel" } },
            { "n", "<Leader>gxo", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
            { "n", "<Leader>gxt", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
            { "n", "<Leader>gxb", actions.conflict_choose("base"), { desc = "Choose BASE" } },
            { "n", "<Leader>gxa", actions.conflict_choose("all"), { desc = "Choose All" } },
            { "n", "<Leader>gxO", actions.conflict_choose_all("ours"), { desc = "Choose OURS (File)" } },
            { "n", "<Leader>gxT", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS (File)" } },
            { "n", "<Leader>gxB", actions.conflict_choose_all("base"), { desc = "Choose BASE (File)" } },
            { "n", "<Leader>gxA", actions.conflict_choose_all("all"), { desc = "Choose All (File)" } },
          },
        },
        view = {
          default = {
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            disable_diagnostics = true,
            winbar_info = true,
          },
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
      }
    end,
  },
}
