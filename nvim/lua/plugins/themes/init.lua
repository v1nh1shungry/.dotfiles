return {
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'wuelnerdotexe/vim-enfocado', lazy = true },
  { 'folke/tokyonight.nvim', lazy = true },
  { 'EdenEast/nightfox.nvim', lazy = true },
  { 'lunarvim/darkplus.nvim', lazy = true },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
  },
  { 'projekt0n/github-nvim-theme', lazy = true },
  { 'nyoom-engineering/oxocarbon.nvim', lazy = true },
  {
    'marko-cerovac/material.nvim',
    init = function() vim.g.material_style = 'darker' end,
    lazy = true,
    opts = {
      plugins = {
        'dap',
        'gitsigns',
        'indent-blankline',
        'lspsaga',
        'neogit',
        'nvim-cmp',
        'nvim-web-devicons',
        'telescope',
        'trouble',
      },
    },
  },
}
