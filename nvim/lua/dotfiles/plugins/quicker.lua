return {
  {
    "stevearc/quicker.nvim",
    event = "VeryLazy", -- NOTE: Doesn't work for location list if `ft = "qf"`.
    keys = {
      { "<Leader>xq", function() require("quicker").toggle() end, desc = "Toggle Quickfix List" },
      { "<Leader>xl", function() require("quicker").toggle({ loclist = true }) end, desc = "Toggle Location List" },
    },
    opts = {
      keys = {
        {
          ">",
          function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end,
          desc = "Expand Context",
        },
        { "<", function() require("quicker").collapse() end, desc = "Collapse Context" },
        { "q", "<Cmd>close<CR>", desc = ":close" },
      },
    },
  },
}
