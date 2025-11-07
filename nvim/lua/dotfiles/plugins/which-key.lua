return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = {
        mappings = false,
      },
      preset = "helix",
      spec = {
        {
          mode = { "n", "x" },
          { "g", group = "goto" },
          { "]", group = "next" },
          { "[", group = "prev" },
          { "z", group = "fold" },
          { "<Space>", group = "leader" },
          { "<Leader><Tab>", group = "tab" },
          { "<Leader>a", group = "agent" },
          { "<Leader>b", group = "buffer" },
          { "<Leader>c", group = "code" },
          { "<Leader>f", group = "file" },
          { "<Leader>g", group = "git" },
          { "<Leader>gx", group = "conflict" },
          { "<Leader>p", group = "package" },
          { "<Leader>q", group = "quit" },
          { "<Leader>s", group = "search" },
          { "<Leader>u", group = "ui" },
          { "<Leader>x", group = "quickfix" },
        },
      },
    },
    opts_extend = { "spec" },
  },
}
