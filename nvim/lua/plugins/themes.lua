return {
  { 'folke/tokyonight.nvim', lazy = true },
  { 'EdenEast/nightfox.nvim', lazy = true },
  {
    'catppuccin/nvim',
    lazy = true,
    name = 'catppuccin',
    opts = {
      integrations = {
        lsp_saga = true,
        lsp_trouble = true,
        mason = true,
        native_lsp = {
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        noice = true,
        notify = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = true,
    opts = {
      overrides = {
        SignColumn = { link = 'LineNr' },
        FoldColumn = { link = 'LineNr' },
      },
    },
  },
}
