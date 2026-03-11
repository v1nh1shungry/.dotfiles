return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    init = function()
      Dotfiles.lsp.register_mappings({
        ["textDocument/codeAction"] = {
          "<Leader>ca",
          function() require("tiny-code-action").code_action() end,
          desc = "Code Action",
          mode = { "n", "x" },
        },
      })
    end,
    lazy = true,
    opts = {
      backend = "delta",
    },
  },
}
