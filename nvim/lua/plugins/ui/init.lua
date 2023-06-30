local config = require('plugins.ui.config')
local events = require('utils.events')

return {
  {
    'skywind3000/vim-quickui',
    config = config.quickui,
    init = function() vim.g.quickui_border_style = 2 end,
    keys = { { '<Space><Space>', '<Cmd>call quickui#menu#open()<CR>', desc = 'Quickui Menu' } },
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
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        opts = { top_down = false },
      },
    },
    event = 'VeryLazy',
    opts = {
      views = { split = { enter = true } },
      presets = { long_message_to_split = true, bottom_search = true, command_palette = true },
      messages = { view_search = false },
      lsp = {
        signature = { enabled = false },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
    },
  },
  {
    'luukvbaal/statuscol.nvim',
    config = config.statuscol,
    event = events.enter_buffer,
  },
  {
    'HiPhish/nvim-ts-rainbow2',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = events.enter_buffer,
  },
  {
    'kevinhwang91/nvim-hlslens',
    config = config.hlslens,
    keys = {
      '/',
      '?',
      { '<C-n>', mode = { 'n', 'v' } }, -- integrate with vim-visual-multi
      { 'n',     [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { 'N',     [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { '*',     [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { '#',     [[#<Cmd>lua require('hlslens').start()<CR>]] },
    },
  },
}
