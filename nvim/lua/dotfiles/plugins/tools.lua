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
      { "<CR>", function() require("kulala").run() end, desc = "Send Request", ft = "http" },
      { "<Tab>", function() require("kulala").open() end, desc = "Open Dashboard", ft = "http" },
      { "yr", function() require("kulala").copy() end, desc = "Copy Request", ft = "http" },
      { "]r", function() require("kulala").jump_next() end, desc = "Next Request", ft = "http" },
      { "[r", function() require("kulala").jump_prev() end, desc = "Previous Request", ft = "http" },
    },
    opts = {},
  },
}
