return {
  {
    "Wansmer/treesj",
    keys = {
      { "S", "<Cmd>TSJSplit<CR>", desc = "Split" },
      { "J", "<Cmd>TSJJoin<CR>", desc = "Join" },
    },
    opts = { use_default_keymaps = false },
  },
  {
    "nvim-mini/mini.surround",
    keys = {
      { "gs", "", mode = { "n", "x" }, desc = "+surround" },
      { "gsa", mode = { "n", "x" }, desc = "Add Surrounding" },
      { "gsd", desc = "Delete Surrounding" },
      { "gsf", desc = "Find Right Surrounding" },
      { "gsF", desc = "Find Left Surrounding" },
      { "gsh", desc = "Highlight Surrounding" },
      { "gsr", desc = "Replace Surrounding" },
    },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
      },
      search_method = "cover_or_next",
    },
  },
  {
    "nvim-mini/mini.align",
    keys = {
      { "ga", mode = { "n", "x" }, desc = "Align" },
      { "gA", mode = { "n", "x" }, desc = "Align with Preview" },
    },
    opts = {},
  },
  {
    "RRethy/nvim-treesitter-endwise",
    config = function()
      -- HACK: Manually trigger `FileType` event to make nvim-treesitter-endwise
      --       attach to current file when loaded
      vim.api.nvim_exec_autocmds("FileType", {})
    end,
    event = "InsertEnter",
  },
  {
    "saghen/blink.pairs",
    build = "cargo build --release",
    event = { "CmdlineEnter", "InsertEnter" },
    opts = {
      highlights = {
        enabled = false,
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<Leader>sg", "<Cmd>GrugFar<CR>", desc = "Search & Replace" },
      { "<Leader>sg", "<Cmd>GrugFarWithin<CR>", desc = "Search & Replace", mode = "x" },
    },
    opts = {},
  },
  {
    "Wansmer/sibling-swap.nvim",
    keys = {
      { "<C-h>", function() require("sibling-swap").swap_with_left() end, desc = "Swap with left" },
      { "<C-l>", function() require("sibling-swap").swap_with_right() end, desc = "Swap with right" },
    },
    opts = { use_default_keymaps = false },
  },
}
