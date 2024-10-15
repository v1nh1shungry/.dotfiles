-- TODO: blink.cmp is impressively fast, but TOO BUGGY to use for now.
--       when it is stable enough we'll switch to blink eventually.
return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    dependencies = {
      {
        "iguanacucumber/magazine.nvim",
        enabled = false,
      },
    },
    -- FIXME: somehow lazy-load will lead to no keymaps
    event = "VeryLazy",
    opts = {
      nerd_font_variant = "mono",
      fuzzy = { prebuiltBinaries = { download = false } },
    },
  },
}
