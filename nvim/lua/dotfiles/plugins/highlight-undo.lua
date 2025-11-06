return {
  {
    "tzachar/highlight-undo.nvim",
    commit = "795fc36f8bb7e4cf05e31bd7e354b86d27643a9e",
    keys = {
      { "u", desc = "Undo" },
      { "<C-r>", desc = "Redo" },
      { "p", desc = "Paste" },
      { "P", desc = "Paste Before" },
    },
    opts = {
      keymaps = {
        undo = { hlgroup = "IncSearch" },
        redo = { hlgroup = "IncSearch" },
        paste = { hlgroup = "IncSearch" },
      },
    },
    pin = true,
  },
}
