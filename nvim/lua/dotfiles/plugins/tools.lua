return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = { { "<Leader>s/", "<Cmd>GrugFar<CR>", desc = "Grep" } },
    opts = {},
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    keys = { { "<CR>", "<Cmd>Rest run<CR>", desc = "Send request", ft = "http" } },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = "DBUI",
    dependencies = "tpope/vim-dadbod",
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "v1nh1shungry/cppman.nvim",
    cmd = "Cppman",
    enabled = vim.fn.executable("cppman") == 1,
    keys = { { "<Leader>sc", "<Cmd>Cppman<CR>", desc = "Cppman" } },
  },
}
