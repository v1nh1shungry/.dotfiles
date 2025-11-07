return {
  {
    "kawre/leetcode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
    },
    lazy = vim.fn.argv()[1] ~= "leetcode.nvim",
    opts = {
      cn = {
        enabled = true,
      },
      injector = {
        cpp = {
          imports = function() return { "#include <bits/stdc++.h>", "using namespace std;" } end,
        },
      },
    },
  },
}
