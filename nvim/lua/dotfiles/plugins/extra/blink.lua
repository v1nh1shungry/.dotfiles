-- TODO: blink.cmp is impressively fast, but TOO BUGGY to use for now.
--       when it is stable enough we'll switch to blink eventually.
return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = "InsertEnter",
    opts = {
      accept = { auto_brackets = { enabled = true } },
      fuzzy = { prebuiltBinaries = { download = false } },
      highlight = { use_nvim_cmp_as_default = false },
      keymap = { preset = "super-tab" },
      nerd_font_variant = "mono",
      sources = {
        completion = {
          enabled_providers = {
            "lsp",
            "lazydev",
            "path",
            "snippets",
            "buffer",
          },
        },
        providers = {
          lsp = { fallback_for = { "lazydev" } },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
        },
      },
      windows = {
        autocomplete = { winblend = require("dotfiles.user").ui.blend },
        documentation = { auto_show = true },
      },
    },
  },
}
