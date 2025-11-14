return {
  {
    "saghen/blink.pairs",
    build = "cargo build --release",
    dependencies = "folke/snacks.nvim",
    event = { "InsertEnter", "LazyFile" },
    opts = {
      highlights = {
        groups = {
          "SnacksIndent1",
          "SnacksIndent2",
          "SnacksIndent3",
          "SnacksIndent4",
          "SnacksIndent5",
          "SnacksIndent6",
          "SnacksIndent7",
          "SnacksIndent8",
        },
      },
      mappings = {
        disabled_filetypes = { "snacks_picker_input" },
      },
    },
  },
}
