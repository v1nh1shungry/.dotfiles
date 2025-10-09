return {
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    init = function()
      Dotfiles.lsp.register_mappings({
        ["textDocument/documentSymbol"] = { "gO", "<Cmd>Outline<CR>", desc = "Symbol Outline" },
      })
    end,
    opts = {
      outline_window = { hide_cursor = true },
      preview_window = { border = "rounded" },
      keymaps = {
        peek_location = {},
        goto_and_close = { "o" },
        up_and_jump = "<C-p>",
        down_and_jump = "<C-n>",
      },
      symbols = { icon_fetcher = function(kind, _) return require("mini.icons").get("lsp", kind) end },
    },
  },
}
