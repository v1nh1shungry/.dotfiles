return {
  {
    "stevearc/quicker.nvim",
    event = "VeryLazy", -- NOTE: Doesn't work for location list if `ft = "qf"`.
    opts = {
      keys = {
        { "q", "<Cmd>close<CR>", desc = ":close" },
      },
    },
  },
}
