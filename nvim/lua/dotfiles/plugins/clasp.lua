return {
  {
    "xzbdmw/clasp.nvim",
    init = function()
      Dotfiles.treesitter.on_available(function(buffer)
        Dotfiles.map({
          "<M-[>",
          function() require("clasp").wrap("prev") end,
          buffer = buffer,
          desc = "Wrap Pairs Backward",
          mode = { "i", "n" },
        })
        Dotfiles.map({
          "<M-]>",
          function() require("clasp").wrap("next") end,
          buffer = buffer,
          desc = "Wrap Pairs Forward",
          mode = { "i", "n" },
        })
      end)
    end,
    lazy = true,
    opts = {},
  },
}
