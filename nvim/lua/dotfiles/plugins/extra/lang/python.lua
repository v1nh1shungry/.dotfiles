---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    ---@module "nvim-treesitter.configs"
    ---@type TSConfig|{}
    opts = { ensure_installed = { "python", "rst" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { ---@type dotfiles.plugins.ide.lspconfig.Config|{}
      servers = {
        basedpyright = {},
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = { settings = { logLevel = "error" } },
        },
      },
      setup = {
        ruff = function()
          Dotfiles.lsp.on_attach(function(client, _) client.server_capabilities.hoverProvider = false end, "ruff")
        end,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "ruff" } }, ---@type dotfiles.mason.Config
  },
}
