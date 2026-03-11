return {
  {
    "xzbdmw/clasp.nvim",
    keys = {
      { "<M-[>", function() require("clasp").wrap("prev") end, mode = { "i", "n" }, desc = "Wrap Pairs Backward" },
      { "<M-]>", function() require("clasp").wrap("next") end, mode = { "i", "n" }, desc = "Wrap Pairs Forward" },
    },
    opts = {},
  },
}
