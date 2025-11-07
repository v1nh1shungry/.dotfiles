return {
  {
    "nvim-mini/mini.operators",
    keys = {
      { "g=", mode = { "n", "v" }, desc = "Evaluate" },
      { "cx", mode = { "n", "v" }, desc = "Exchange" },
      { "gm", mode = { "n", "v" }, desc = "Duplicate" },
      { "gr", mode = { "n", "v" }, desc = "Replace with Register" },
      { "gS", mode = { "n", "v" }, desc = "Sort" },
    },
    opts = {
      sort = {
        prefix = "gS",
      },
      exchange = {
        prefix = "cx",
      },
    },
  },
}
