return {
  {
    "nvim-mini/mini.surround",
    keys = {
      { "gs", "", mode = { "n", "x" }, desc = "+surround" },
      { "gsa", mode = { "n", "x" }, desc = "Add Surrounding" },
      { "gsd", desc = "Delete Surrounding" },
      { "gsf", desc = "Find Right Surrounding" },
      { "gsF", desc = "Find Left Surrounding" },
      { "gsh", desc = "Highlight Surrounding" },
      { "gsr", desc = "Replace Surrounding" },
    },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
      },
      search_method = "cover_or_next",
    },
  },
}
