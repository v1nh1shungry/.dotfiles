local config = require('plugins.ui.config')
local events = require('utils.events')

return {
  {
    'skywind3000/vim-quickui',
    config = config.quickui,
    init = function() vim.g.quickui_border_style = 2 end,
    keys = { { '<Space><Space>', mode = { 'n', 'v' } }, { 'K', mode = { 'n', 'v' } } },
  },
  {
    'folke/todo-comments.nvim',
    cmd = 'TodoTrouble',
    dependencies = 'nvim-lua/plenary.nvim',
    event = events.enter_buffer,
    keys = {
      { '[t', function() require('todo-comments').jump_prev() end },
      { ']t', function() require('todo-comments').jump_next() end },
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
    keys = { '<Leader>mo', '<Leader>mm' },
  },
  {
    'lewis6991/satellite.nvim',
    event = events.enter_buffer,
    opts = config.satellite,
  },
  {
    'rcarriga/nvim-notify',
    init = config.notify,
    lazy = true,
  },
  {
    'simeji/winresizer',
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
    dependencies = { 'jcdickinson/wpm.nvim', config = true },
    event = events.enter_buffer,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = true,
    event = events.enter_buffer,
  },
  {
    'mrjones2014/nvim-ts-rainbow',
    event = events.enter_buffer,
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  },
  {
    'AckslD/messages.nvim',
    cmd = 'Messages',
    config = true,
  },
}
