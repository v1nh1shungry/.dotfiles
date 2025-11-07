return {
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "LazyFile",
    keys = {
      { "<Leader>xt", "<Cmd>TodoQuickFix keywords=TODO,FIXME<CR>", desc = "Todo" },
      { "<Leader>xT", "<Cmd>TodoQuickFix<CR>", desc = "Todo & Note" },
      ---@diagnostic disable-next-line: undefined-field
      { "<Leader>st", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIXME" } }) end, desc = "Todo" },
      ---@diagnostic disable-next-line: undefined-field
      { "<Leader>sT", function() Snacks.picker.todo_comments() end, desc = "Todo & Note" },
    },
    opts = {
      signs = false,
    },
  },
}
