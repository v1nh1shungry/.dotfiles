return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = { { "<Leader>s/", "<Cmd>GrugFar<CR>", desc = "Search & Replace" } },
    opts = {},
  },
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    keys = {
      { "<CR>", function() require("kulala").open() end, desc = "Send Request", ft = "http" },
      { "yr", function() require("kulala").copy() end, desc = "Copy Request", ft = "http" },
      { "]r", function() require("kulala").jump_next() end, desc = "Next Request", ft = "http" },
      { "[r", function() require("kulala").jump_prev() end, desc = "Previous Request" },
    },
    opts = { ui = { display_mode = "float" } },
  },
  {
    "v1nh1shungry/cppman.nvim",
    cmd = "Cppman",
    enabled = vim.fn.executable("cppman") == 1,
    keys = { { "<Leader>sc", "<Cmd>Cppman<CR>", desc = "Cppman" } },
    opts = { picker = "snacks" },
  },
}
