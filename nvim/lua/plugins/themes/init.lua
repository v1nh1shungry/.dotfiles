return {
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
  },
  {
    'wuelnerdotexe/vim-enfocado',
    lazy = true,
  },
  {
    'folke/tokyonight.nvim',
    lazy = true,
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = true,
  },
  {
    'lunarvim/darkplus.nvim',
    lazy = true,
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = true,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
  },
  {
    'projekt0n/github-nvim-theme',
    lazy = true,
  },
  {
    'srcery-colors/srcery-vim',
    dependencies = 'folke/lsp-colors.nvim',
    lazy = true,
  },
  {
    'bluz71/vim-moonfly-colors',
    config = function() vim.g.moonflyVirtualTextColor = true end,
    lazy = true,
  },
  {
    'bluz71/vim-nightfly-colors',
    config = function() vim.g.nightflyVirtualTextColor = true end,
    lazy = true,
  },
}
