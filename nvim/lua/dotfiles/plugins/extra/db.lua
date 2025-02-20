vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_save_location = vim.fs.joinpath(vim.fn.stdpath("data"), "dadbod_ui")
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_use_nvim_notify = true

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = "DBUI",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = { sql = { "dadbod" } },
        providers = {
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
          },
        },
      },
    },
  },
  {
    "folke/edgy.nvim",
    opts = {
      left = {
        {
          ft = "dbui",
          title = "DBUI",
        },
      },
      bottom = {
        {
          ft = "dbout",
          title = "DB Query Result",
        },
      },
    },
  },
}
