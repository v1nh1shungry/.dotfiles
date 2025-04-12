vim.lsp.enable("vtsls")

---@module "lazy.types"
---@type LazySpec[]
return {
  -- https://www.lazyvim.org/extras/lang/typescript {{{
  {
    "nvim-treesitter/nvim-treesitter",
    ---@module "nvim-treesitter.configs"
    ---@type TSConfig|{}
    opts = { ensure_installed = { "javascript", "jsdoc", "tsx", "typescript" } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "vtsls" } },
  },
  -- }}}
}
