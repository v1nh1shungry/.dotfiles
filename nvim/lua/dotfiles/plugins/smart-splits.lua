return {
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    keys = {
      { "<M-h>", function() require("smart-splits").move_cursor_left() end, desc = "Left Window", mode = { "n", "t" } },
      {
        "<M-l>",
        function() require("smart-splits").move_cursor_right() end,
        desc = "Right window",
        mode = { "n", "t" },
      },
      {
        "<M-j>",
        function() require("smart-splits").move_cursor_down() end,
        desc = "Lower Window",
        mode = { "n", "t" },
      },
      { "<M-k>", function() require("smart-splits").move_cursor_up() end, desc = "Upper Window", mode = { "n", "t" } },
      { "<M-Left>", function() require("smart-splits").resize_left() end, desc = "Shift Left" },
      { "<M-Right>", function() require("smart-splits").resize_right() end, desc = "Shift Right" },
      { "<M-Down>", function() require("smart-splits").resize_down() end, desc = "Shift Down" },
      { "<M-Up>", function() require("smart-splits").resize_up() end, desc = "Shift Up" },
    },
  },
}
