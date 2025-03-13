---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    keys = {
      {
        "<Leader>xH",
        function() require("gitsigns").setqflist("all") end,
        desc = "Workspace Git Hunks",
      },
      { "<Leader>ub", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Git Blame" },
    },
    ---@module "gitsigns.config"
    ---@type Gitsigns.Config|{}
    opts = {
      on_attach = function(bufnr)
        local map = Dotfiles.map_with({ buffer = bufnr })
        map({ "<Leader>ga", ":Gitsigns stage_hunk<CR>", mode = { "n", "x" }, desc = "Stage Hunk" })
        map({ "<Leader>gA", "<Cmd>Gitsigns stage_buffer<CR>", desc = "Stage Current Buffer" })
        map({ "<Leader>gu", "<Cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo Staged Hunk" })
        map({ "<Leader>gp", "<Cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview Hunk" })
        map({ "<Leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", mode = { "n", "x" }, desc = "Reset Hunk" })
        map({ "<Leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "Reset Current Buffer" })
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
        map({ "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git Hunk" })
        map({ "ah", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git Hunk" })
        map({ "<Leader>xh", "<Cmd>Gitsigns setloclist<CR>", desc = "Document Git Hunks" })
        map({ "<Leader>gd", "<Cmd>Gitsigns diffthis<CR>", desc = "Diffthis" })
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

      local opts = { ---@type DiffviewConfig
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
            {
              "n",
              "<Leader>gxo",
              actions.conflict_choose("ours"),
              { desc = "Choose OURS" },
            },
            {
              "n",
              "<Leader>gxt",
              actions.conflict_choose("theirs"),
              { desc = "Choose THEIRS" },
            },
            {
              "n",
              "<Leader>gxb",
              actions.conflict_choose("base"),
              { desc = "Choose BASE" },
            },
            {
              "n",
              "<Leader>gxa",
              actions.conflict_choose("all"),
              { desc = "Choose All" },
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
              { desc = "Choose OURS (File)" },
            },
            {
              "n",
              "<Leader>gxT",
              actions.conflict_choose_all("theirs"),
              { desc = "Choose THEIRS (File)" },
            },
            {
              "n",
              "<Leader>gxB",
              actions.conflict_choose_all("base"),
              { desc = "Choose BASE (File)" },
            },
            {
              "n",
              "<Leader>gxA",
              actions.conflict_choose_all("all"),
              { desc = "Choose All (File)" },
            },
          },
        },
        hooks = {
          view_opened = function() require("diffview.actions").toggle_files() end,
        },
      }

      opts.keymaps.file_panel = vim.tbl_deep_extend("force", opts.keymaps.file_panel, opts.keymaps.file_history_panel)
      opts.keymaps.view = vim.tbl_deep_extend("force", opts.keymaps.file_panel, opts.keymaps.view)

      require("diffview").setup(opts)
    end,
    keys = {
      { "<Leader>gD", "<Cmd>DiffviewOpen<CR>", desc = "Git Diff Pane" },
      {
        "<Leader>gh",
        function() vim.cmd("DiffviewFileHistory" .. (vim.bo.buftype == "" and " %" or "")) end,
        desc = "Git History",
      },
    },
  },
}
