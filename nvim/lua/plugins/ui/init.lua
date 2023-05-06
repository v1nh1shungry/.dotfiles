local config = require('plugins.ui.config')
local events = require('utils.events')

return {
  {
    'skywind3000/vim-quickui',
    config = config.quickui,
    init = function() vim.g.quickui_border_style = 2 end,
    keys = {
      { '<Space><Space>', '<Cmd>call quickui#menu#open()<CR>', desc = 'Quickui Menu' },
      '<M-Space>',
    },
  },
  {
    'folke/todo-comments.nvim',
    cmd = 'TodoTrouble',
    dependencies = 'nvim-lua/plenary.nvim',
    event = events.enter_buffer,
    keys = {
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous TODO' },
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next TODO' },
    },
    opts = { signs = false },
  },
  {
    'goolord/alpha-nvim',
    config = config.alpha,
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {
    'gorbit99/codewindow.nvim',
    config = config.codewindow,
    keys = {
      { '<Leader>mo', desc = 'Open Minimap' },
      { '<Leader>mm', desc = 'Toggle Minimap' },
    },
  },
  {
    'lewis6991/satellite.nvim',
    event = events.enter_buffer,
    opts = { excluded_filetypes = require('utils.ui').excluded_filetypes },
  },
  {
    'simeji/winresizer',
    cmd = 'WinResizerStartResize',
    keys = '<C-e>',
  },
  {
    'akinsho/bufferline.nvim',
    config = config.bufferline,
    event = events.enter_buffer,
  },
  {
    'stevearc/dressing.nvim',
    init = config.dressing,
    lazy = true,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = config.lualine,
    event = events.enter_buffer,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = true,
    event = events.enter_buffer,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      window = { winblend = require('user').ui.blend },
      layout = { height = { max = 10 } },
    },
  },
  {
    'chikko80/error-lens.nvim',
    config = true,
    dependencies = 'nvim-telescope/telescope.nvim',
    event = 'LspAttach',
  },
  {
    'folke/noice.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    event = 'VeryLazy',
    opts = { lsp = { progress = { enabled = false } } },
  },
}
