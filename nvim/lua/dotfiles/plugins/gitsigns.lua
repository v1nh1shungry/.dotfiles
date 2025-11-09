return {
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    keys = {
      { "<Leader>xH", function() require("gitsigns").setqflist("all") end, desc = "Git Hunks (Workspace)" },
      { "<Leader>ub", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Git Blame" },
    },
    opts = {
      attach_to_untracked = true,
      current_line_blame = true,
      on_attach = function(bufnr)
        local map = Dotfiles.map_with({ buffer = bufnr })
        map({ "<Leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk", mode = { "n", "x" } })
        map({ "<Leader>gS", "<Cmd>Gitsigns stage_buffer<CR>", desc = "Stage Whole Buffer" })
        map({ "<Leader>gp", "<Cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview Hunk (inline)" })
        map({ "<Leader>gP", "<Cmd>Gitsigns preview_hunk<CR>", desc = "Preview Hunk (popup)" })
        map({ "<Leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk", mode = { "n", "x" } })
        map({ "<Leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "Reset Whole Buffer" })
        map({ "<Leader>gb", "<Cmd>Gitsigns blame_line<CR>", desc = "Blame this Line" })
        map({ "<Leader>gB", "<Cmd>Gitsigns blame<CR>", desc = "Blame" })
        map({
          "]h",
          function() require("gitsigns").nav_hunk("next", { navigation_message = false }) end,
          desc = "Next Git Hunk",
        })
        map({
          "[h",
          function() require("gitsigns").nav_hunk("prev", { navigation_message = false }) end,
          desc = "Previous Git Hunk",
        })
        map({
          "]H",
          function() require("gitsigns").nav_hunk("last", { navigation_message = false }) end,
          desc = "Last Git Hunk",
        })
        map({
          "[H",
          function() require("gitsigns").nav_hunk("first", { navigation_message = false }) end,
          desc = "First Git Hunk",
        })
        map({ "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Git Hunk", mode = { "o", "x" } })
        map({ "ah", ":<C-U>Gitsigns select_hunk<CR>", desc = "Git Hunk", mode = { "o", "x" } })
        map({ "<Leader>xh", "<Cmd>Gitsigns setloclist<CR>", desc = "Git Hunks (Document)" })
        map({ "<Leader>gd", "<Cmd>Gitsigns diffthis<CR>", desc = "Diffthis" })
      end,
    },
  },
}
