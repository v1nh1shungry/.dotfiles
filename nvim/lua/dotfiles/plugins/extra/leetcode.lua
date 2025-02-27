---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "kawre/leetcode.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = vim.fn.argv()[1] ~= "leetcode.nvim",
    opts = {
      cn = { enabled = true },
      injector = { cpp = { before = { "#include <bits/stdc++.h>", "using namespace std;" } } },
    },
  },
}
