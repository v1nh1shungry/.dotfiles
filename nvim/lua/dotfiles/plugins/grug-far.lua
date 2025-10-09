return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<Leader>sg", "<Cmd>GrugFar<CR>", desc = "Search & Replace" },
      { "<Leader>sg", "<Cmd>GrugFarWithin<CR>", desc = "Search & Replace", mode = "x" },
      { "<Leader>sG", function() require("grug-far").open({ engine = "astgrep" }) end, desc = "AST Grep" },
    },
    opts = {},
  },
}
