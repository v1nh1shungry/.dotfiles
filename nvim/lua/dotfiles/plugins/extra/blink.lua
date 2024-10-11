-- TODO: blink.cmp is impressively fast, but TOO BUGGY to use for now.
--       when it is stable enough we'll switch to blink eventually.
local events = require("dotfiles.utils.events")

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
    event = events.enter_insert,
    opts = {
      highlight = { use_nvim_cmp_as_default = true },
      nerd_font_variant = "mono",
      keymap = {
        select_prev = { "<C-p>" },
        select_next = { "<C-n>" },
      },
      fuzzy = { prebuiltBinaries = { download = false } },
    },
  },
}
