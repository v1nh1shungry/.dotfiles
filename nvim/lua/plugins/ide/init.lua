local config = require('plugins.ide.config')
local events = require('utils.events')

return {
  {
    'neovim/nvim-lspconfig',
    config = config.lspconfig,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'folke/neodev.nvim',
      'p00f/clangd_extensions.nvim',
      'williamboman/mason-lspconfig.nvim',
      {
        'jose-elias-alvarez/null-ls.nvim',
        config = config.null_ls,
        dependencies = { 'nvim-lua/plenary.nvim', 'jay-babu/mason-null-ls.nvim' },
      },
      'ray-x/lsp_signature.nvim',
      {
        'lvimuser/lsp-inlayhints.nvim',
        config = true,
      },
    },
    event = events.enter_buffer,
  },
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = { sources = { ['null-ls'] = { ignore = true } } },
  },
  {
    'glepnir/lspsaga.nvim',
    config = config.lspsaga,
    event = 'LspAttach',
  },
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    config = true,
    lazy = true,
  },
  {
    'hrsh7th/nvim-cmp',
    config = config.cmp,
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      {
        'saadparwaiz1/cmp_luasnip',
        dependencies = 'L3MON4D3/LuaSnip',
      },
      'onsails/lspkind.nvim',
      'lukas-reineke/cmp-rg',
    },
    event = events.enter_insert,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = config.gitsigns,
    event = events.enter_buffer,
  },
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = '<M-=>',
    opts = { open_mapping = '<M-=>', size = 10 },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    cmd = 'NeoTreeFocusToggle',
    config = config.tree,
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    keys = { { '<Leader>e', '<Cmd>NeoTreeFocusToggle<CR>' } },
  },
  {
    'mfussenegger/nvim-dap',
    config = config.dap,
    dependencies = {
      'rcarriga/nvim-dap-ui',
      {
        'theHamsta/nvim-dap-virtual-text',
        config = true,
      },
      'jay-babu/mason-nvim-dap.nvim',
    },
    keys = {
      { '<F9>', '<Cmd>DapToggleBreakpoint<CR>' },
      { '<F5>', '<Cmd>DapContinue<CR>' },
    },
  },
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'TroubleRefresh', 'TodoTrouble' },
  },
  {
    'DNLHC/glance.nvim',
    cmd = 'Glance',
  },
}
