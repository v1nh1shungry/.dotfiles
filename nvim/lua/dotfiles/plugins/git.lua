local events = require("dotfiles.utils.events")
local map = require("dotfiles.utils.keymap")

return {
  {
    "lewis6991/gitsigns.nvim",
    event = events.enter_buffer,
    opts = {
      on_attach = function(buffer)
        local map_local = function(opts)
          opts.buffer = buffer
          map(opts)
        end
        map_local({ "<Leader>gp", "<Cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" })
        map_local({ "<Leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk" })
        map_local({ "<Leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "Reset current buffer" })
        map_local({ "<Leader>gb", "<Cmd>Gitsigns blame_line<CR>", desc = "Blame this line" })
        map_local({ "<Leader>gd", "<Cmd>Gitsigns diffthis<CR>", desc = "Diffthis" })
        map_local({ "<Leader>ub", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle git blame" })
        map_local({
          "]h",
          function() require("gitsigns").nav_hunk("next", { navigation_message = false }) end,
          desc = "Next git hunk",
        })
        map_local({
          "[h",
          function() require("gitsigns").nav_hunk("prev", { navigation_message = false }) end,
          desc = "Previous git hunk",
        })
        map_local({
          "]H",
          function() require("gitsigns").nav_hunk("last", { navigation_message = false }) end,
          desc = "Last git hunk",
        })
        map_local({
          "[H",
          function() require("gitsigns").nav_hunk("first", { navigation_message = false }) end,
          desc = "First git hunk",
        })
        map_local({ "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git hunk" })
        map_local({ "ah", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git hunk" })
        map_local({ "<Leader>xh", "<Cmd>Gitsigns setqflist<CR>", desc = "Git hunks" })
      end,
      attach_to_untracked = true,
      current_line_blame = true,
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    config = function()
      local actions = require("diffview.actions")
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = { merge_tool = { layout = "diff3_mixed" } },
        keymaps = {
          view = {
            { "n", "<leader>e", actions.toggle_files, { desc = "Bring focus to the file panel" } },
            ["<leader>b"] = false,
            ["<leader>co"] = false,
            ["<leader>ct"] = false,
            ["<leader>cb"] = false,
            ["<leader>ca"] = false,
            ["<leader>cO"] = false,
            ["<leader>cT"] = false,
            ["<leader>cB"] = false,
            ["<leader>cA"] = false,
            {
              "n",
              "<Leader>gxo",
              actions.conflict_choose("ours"),
              { desc = "Choose the OURS version of a conflict" },
            },
            {
              "n",
              "<Leader>gxt",
              actions.conflict_choose("theirs"),
              { desc = "Choose the THEIRS version of a conflict" },
            },
            {
              "n",
              "<Leader>gxb",
              actions.conflict_choose("base"),
              { desc = "Choose the BASE version of a conflict" },
            },
            {
              "n",
              "<Leader>gxa",
              actions.conflict_choose("all"),
              { desc = "Choose all the versions of a conflict" },
            },
            {
              "n",
              "<Leader>gxO",
              actions.conflict_choose_all("ours"),
              { desc = "Choose the OURS version of a conflict for the whole file" },
            },
            {
              "n",
              "<Leader>gxT",
              actions.conflict_choose_all("theirs"),
              { desc = "Choose the THEIRS version of a conflict for the whole file" },
            },
            {
              "n",
              "<Leader>gxB",
              actions.conflict_choose_all("base"),
              { desc = "Choose the BASE version of a conflict for the whole file" },
            },
            {
              "n",
              "<Leader>gxA",
              actions.conflict_choose_all("all"),
              { desc = "Choose all the versions of a conflict for the whole file" },
            },
          },
          file_panel = {
            { "n", "<leader>e", actions.toggle_files, { desc = "Bring focus to the file panel" } },
            ["<leader>b"] = false,
          },
        },
      })
    end,
    keys = { { "<Leader>gD", "<Cmd>DiffviewOpen<CR>", desc = "Open git diff pane" } },
  },
  {
    "chrisgrieser/nvim-tinygit",
    dependencies = { "stevearc/dressing.nvim", "nvim-telescope/telescope.nvim", "rcarriga/nvim-notify" },
    ft = { "gitcommit", "git_rebase" },
    keys = {
      { "<Leader>gc", function() require("tinygit").smartCommit() end, desc = "Commit" },
      { "<Leader>gP", function() require("tinygit").push({}) end, desc = "Push" },
      { "<Leader>ga", function() require("tinygit").amendNoEdit() end, desc = "Amend" },
      { "<Leader>gU", function() require("tinygit").undoLastCommitOrAmend() end, desc = "Undo last commit" },
      { "<Leader>gs", function() require("tinygit").searchFileHistory() end, desc = "Search file history" },
      { "<Leader>gS", function() require("tinygit").functionHistory() end, desc = "Search function history" },
      { "<Leader>gf", function() require("tinygit").githubUrl() end, desc = "Open in Github" },
    },
  },
  {
    "echasnovski/mini-git",
    main = "mini.git",
    cmd = "Git",
    opts = {},
  },
}
