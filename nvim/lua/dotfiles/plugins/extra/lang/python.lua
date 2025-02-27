---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    ---@module "nvim-treesitter.configs"
    ---@type TSConfig|{}
    opts = { ensure_installed = { "python" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { ---@type dotfiles.lspconfig.Config|{}
      servers = {
        basedpyright = {},
        ruff = {
          on_attach = function(client)
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "ruff" } }, ---@type dotfiles.mason.Config
  },
}
