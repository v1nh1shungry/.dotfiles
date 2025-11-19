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
    dependencies = "MunifTanjim/nui.nvim",
    event = "VeryLazy",
    init = function()
      ---@param delta integer
      ---@param fallback string
      ---@return fun(): string?
      local function scroll_lsp_doc(delta, fallback)
        return function()
          local win = vim.b.lsp_floating_preview
          if not win or not vim.api.nvim_win_is_valid(win) then
            return fallback
          end

          require("noice.util.nui").scroll(win, delta)
        end
      end

      Dotfiles.lsp.register_mappings({
        ["textDocument/hover"] = {
          { "<C-f>", scroll_lsp_doc(5, "<C-f>"), desc = "Scroll Down Lsp Document", expr = true },
          { "<C-b>", scroll_lsp_doc(-5, "<C-b>"), desc = "Scroll Up Lsp Document", expr = true },
        },
      })
    end,
    keys = {
      { "<Leader>un", "<Cmd>Noice dismiss<CR>", desc = "Dismiss All Messages" },
      { "<Leader>xn", "<Cmd>NoiceAll<CR>", desc = "Message" },
    },
    opts = {
      lsp = {
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            max_height = 1,
          },
          view = "mini",
        },
        {
          filter = {
            event = "msg_show",
            min_height = 10,
          },
          view = "cmdline_output",
        },
      },
      views = {
        split = {
          enter = true,
        },
      },
    },
  },
}
