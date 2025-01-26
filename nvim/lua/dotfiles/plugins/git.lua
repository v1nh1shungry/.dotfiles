return {
  {
    "lewis6991/gitsigns.nvim",
    event = Dotfiles.events.enter_buffer,
    keys = {
      {
        "<Leader>xH",
        function()
          require("gitsigns").setqflist("all")
        end,
        desc = "Workspace git hunks",
      },
      { "<Leader>ub", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle git blame" },
    },
    opts = {
      on_attach = function(buffer)
        local map = function(opts)
          opts.buffer = buffer
          Dotfiles.map(opts)
        end
        map({ "<Leader>ga", ":Gitsigns stage_hunk<CR>", mode = { "n", "x" }, desc = "Stage hunk" })
        map({ "<Leader>gA", "<Cmd>Gitsigns stage_buffer<CR>", desc = "Stage current buffer" })
        map({ "<Leader>gu", "<Cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo staged hunk" })
        map({ "<Leader>gp", "<Cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" })
        map({ "<Leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", mode = { "n", "x" }, desc = "Reset hunk" })
        map({ "<Leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "Reset current buffer" })
        map({ "<Leader>gb", "<Cmd>Gitsigns blame_line<CR>", desc = "Blame this line" })
        map({ "<Leader>gB", "<Cmd>Gitsigns blame<CR>", desc = "Blame" })
        map({
          "]h",
          function()
            require("gitsigns").nav_hunk("next", { navigation_message = false })
          end,
          desc = "Next git hunk",
        })
        map({
          "[h",
          function()
            require("gitsigns").nav_hunk("prev", { navigation_message = false })
          end,
          desc = "Previous git hunk",
        })
        map({
          "]H",
          function()
            require("gitsigns").nav_hunk("last", { navigation_message = false })
          end,
          desc = "Last git hunk",
        })
        map({
          "[H",
          function()
            require("gitsigns").nav_hunk("first", { navigation_message = false })
          end,
          desc = "First git hunk",
        })
        map({ "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git hunk" })
        map({ "ah", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git hunk" })
        map({ "<Leader>xh", "<Cmd>Gitsigns setloclist<CR>", desc = "Document git hunks" })
      end,
      attach_to_untracked = true,
      current_line_blame = true,
    },
  },
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
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle file panel" } },
            ["<leader>b"] = false,
          },
          view = {
            ["<leader>co"] = false,
            ["<leader>ct"] = false,
            ["<leader>cb"] = false,
            ["<leader>ca"] = false,
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
          },
          file_panel = {
            ["<leader>cO"] = false,
            ["<leader>cT"] = false,
            ["<leader>cB"] = false,
            ["<leader>cA"] = false,
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
        },
        hooks = {
          view_opened = function()
            require("diffview.actions").toggle_files()
          end,
        },
      }

      opts.keymaps.file_panel = vim.tbl_deep_extend("force", opts.keymaps.file_panel, opts.keymaps.file_history_panel)
      opts.keymaps.view = vim.tbl_deep_extend("force", opts.keymaps.file_panel, opts.keymaps.view)

      require("diffview").setup(opts)
    end,
    keys = {
      { "<Leader>gD", "<Cmd>DiffviewOpen<CR>", desc = "Open git diff pane" },
      {
        "<Leader>gh",
        function()
          vim.cmd("DiffviewFileHistory" .. (vim.bo.buftype == "" and " %" or ""))
        end,
        desc = "Git history",
      },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gedit", "Gvdiffsplit", "Gread", "Gwrite", "GMove", "GRename", "GDelete" },
    keys = { { "<Leader>gd", "<Cmd>Gvdiffsplit<CR>", desc = "Diff this" } },
  },
}
