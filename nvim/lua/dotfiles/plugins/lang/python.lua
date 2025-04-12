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
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "basedpyright", "ruff" } },
  },
}
