-- TODO: Almost ready to use, but still unstable.
--       I'd say as the code base grows, blink is not so impressive now :(
return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = "InsertEnter",
    opts = {
      accept = { auto_brackets = { enabled = true } },
      fuzzy = { prebuiltBinaries = { download = false } },
      keymap = { preset = "super-tab" },
      nerd_font_variant = "mono",
      completion = {
        menu = { winblend = vim.o.pumblend },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        list = { selection = "auto_insert" },
      },
      sources = {
        completion = {
          enabled_providers = {
            "lsp",
            "snippets",
            "path",
            "buffer",
          },
        },
      },
    },
    opts_extend = { "sources.completion.enabled_providers" },
  },
}
