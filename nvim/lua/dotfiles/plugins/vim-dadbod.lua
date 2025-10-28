return {
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = "DBUI",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    init = function()
      vim.g.db_ui_auto_execute_table_helpers = true
      vim.g.db_ui_save_location = vim.fs.joinpath(vim.fn.stdpath("data"), "dadbod_ui")
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          mysql = { "dadbod" },
          plsql = { "dadbod" },
          sql = { "dadbod" },
        },
        providers = {
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
          },
        },
      },
    },
  },
}
