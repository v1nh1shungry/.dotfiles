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
    "akinsho/git-conflict.nvim",
    config = function(_, opts)
      require("git-conflict").setup(opts)
      vim.api.nvim_create_autocmd("User", {
        callback = function(args)
          local map_local = function(key)
            key.buffer = args.buf
            map(key)
          end
          map_local({ "<Leader>gxo", "<Plug>(git-conflict-ours)", desc = "Choose ours" })
          map_local({ "<Leader>gxt", "<Plug>(git-conflict-theirs)", desc = "Choose theirs" })
          map_local({ "<Leader>gxb", "<Plug>(git-conflict-both)", desc = "Choose both" })
          map_local({ "<Leader>gx0", "<Plug>(git-conflict-none)", desc = "Choose none" })
        end,
        pattern = "GitConflictDetected",
      })
    end,
    event = events.enter_buffer,
    opts = { default_mappings = false },
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
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
