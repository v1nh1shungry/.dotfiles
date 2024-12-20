-- TODO: Almost ready to use, but still unstable.
--       I'd say as the code base grows, blink is not so impressive now :(
return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = "InsertEnter",
    opts = {
      appearance = { nerd_font_variant = "mono" },
      fuzzy = { prebuilt_binaries = { download = false } },
      keymap = { preset = "super-tab" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { draw = { align_to_component = "none" } },
      },
      sources = { default = { "lsp", "snippets", "path", "buffer" } },
    },
    opts_extend = { "sources.default" },
  },
}
