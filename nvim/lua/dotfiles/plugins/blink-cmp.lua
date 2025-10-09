return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = "VeryLazy",
    opts = {
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        list = {
          selection = {
            preselect = function() return not require("blink.cmp").snippet_active({ direction = 1 }) end,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
      },
      fuzzy = {
        prebuilt_binaries = {
          download = false,
        },
      },
      keymap = { preset = "super-tab" },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
      },
    },
  },
}
