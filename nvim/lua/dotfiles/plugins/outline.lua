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
      keymaps = {
        down_and_jump = "<C-n>",
        goto_and_close = { "o" },
        peek_location = {},
        up_and_jump = "<C-p>",
      },
      outline_window = {
        hide_cursor = true,
      },
      preview_window = {
        border = "rounded",
      },
      symbols = {
        icon_fetcher = function(kind, _) return require("mini.icons").get("lsp", kind) end,
      },
    },
  },
}
