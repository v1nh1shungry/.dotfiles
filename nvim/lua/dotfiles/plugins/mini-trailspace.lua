return {
  {
    "nvim-mini/mini.trailspace",
    event = "LazyFile",
    keys = { { "d<Space>", function() require("mini.trailspace").trim() end, desc = "Trim Trailing Space" } },
    opts = {},
  },
}
