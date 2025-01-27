return {
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = "DBUI",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
      {
        "saghen/blink.cmp",
        opts = {
          sources = {
            default = { "dadbod" },
            providers = {
              dadbod = {
                name = "Dadbod",
                module = "vim_dadbod_completion.blink",
              },
            },
          },
        },
      },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
    end,
  },
}
