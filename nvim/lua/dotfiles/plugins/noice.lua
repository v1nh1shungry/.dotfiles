return {
  {
    "folke/noice.nvim",
    -- https://github.com/LazyVim/LazyVim {{{
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      --       but this is not ideal when Lazy is installing
      --       plugins, so we clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end

      require("noice").setup(opts)
    end,
    -- }}}
    event = "VeryLazy",
    keys = {
      { "<Leader>un", "<Cmd>Noice dismiss<CR>", desc = "Dismiss All Messages" },
      { "<Leader>xn", "<Cmd>NoiceAll<CR>", desc = "Message" },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      routes = {
        {
          filter = {
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
            event = "msg_show",
          },
          view = "mini",
        },
      },
      views = { split = { enter = true } },
    },
  },
}
