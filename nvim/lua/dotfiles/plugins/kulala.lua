return {
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    keys = {
      { "<CR>", function() require("kulala").run() end, desc = "Send Request", ft = "http" },
      { "<Tab>", function() require("kulala").open() end, desc = "Open Dashboard", ft = "http" },
      { "yr", function() require("kulala").copy() end, desc = "Copy Request", ft = "http" },
      { "]]", function() require("kulala").jump_next() end, desc = "Next Request", ft = "http" },
      { "[[", function() require("kulala").jump_prev() end, desc = "Previous Request", ft = "http" },
      { "<Leader>fn", function() require("kulala").scratchpad() end, desc = "Kulala Scratchpad" },
    },
    opts = {
      scratchpad_default_contents = {},
      ui = {
        win_opts = {
          wo = {
            signcolumn = "no",
          },
        },
      },
    },
  },
}
