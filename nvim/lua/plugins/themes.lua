return {
  { 'wuelnerdotexe/vim-enfocado', lazy = true },
  { 'folke/tokyonight.nvim',      lazy = true },
  { 'EdenEast/nightfox.nvim',     lazy = true },
  {
    'catppuccin/nvim',
    lazy = true,
    name = 'catppuccin',
    opts = {
      integrations = {
        lsp_saga = true,
        mason = true,
        neotree = true,
        noice = true,
        notify = true,
        treesitter_context = true,
        lsp_trouble = true,
        which_key = true,
      },
    },
  },
}
