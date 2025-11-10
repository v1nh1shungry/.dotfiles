return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = false,
      },
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
      },
      fuzzy = {
        prebuilt_binaries = {
          download = false,
        },
      },
      keymap = {
        preset = "super-tab",
      },
      signature = {
        enabled = true,
      },
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
  },
}
