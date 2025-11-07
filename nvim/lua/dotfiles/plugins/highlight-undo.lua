return {
  {
    "tzachar/highlight-undo.nvim",
    commit = "795fc36f8bb7e4cf05e31bd7e354b86d27643a9e",
    keys = {
      { "<C-r>", desc = "Redo" },
      { "P", desc = "Paste Before" },
      { "p", desc = "Paste" },
      { "u", desc = "Undo" },
    },
    opts = {
      keymaps = {
        Paste = {
          hlgroup = "IncSearch",
        },
        paste = {
          hlgroup = "IncSearch",
        },
        redo = {
          hlgroup = "IncSearch",
        },
        undo = {
          hlgroup = "IncSearch",
        },
      },
    },
    pin = true,
  },
}
