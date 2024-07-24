return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "black" })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
      },
    },
  },
  {
    "monaqa/dial.nvim",
    opts = function(_, opts)
      local augend = require("dial.augend")

      opts = vim.tbl_deep_extend("force", opts or {}, {
        python = {
          augend.integer.alias.decimal,
          augend.constant.new({ elements = { "True", "False" } }),
          augend.constant.new({ elements = { "&&", "||" } }),
          augend.constant.new({ elements = { "==", "!=" } }),
        },
      })
    end,
  },
}
