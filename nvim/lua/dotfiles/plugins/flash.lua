return {
  {
    "folke/flash.nvim",
    keys = {
      { "f", mode = { "n", "x", "o" } },
      { "F", mode = { "n", "x", "o" } },
      { "t", mode = { "n", "x", "o" } },
      { "T", mode = { "n", "x", "o" } },
      { ",", mode = { "n", "x", "o" } },
      { ";", mode = { "n", "x", "o" } },
      { "r", function() require("flash").remote() end, desc = "Remote Flash", mode = "o" },
    },
    opts = {},
  },
}
