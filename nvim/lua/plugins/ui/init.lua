local config = require('plugins.ui.config')
local events = require('utils.events')

return {
  {
    'folke/todo-comments.nvim',
    cmd = 'TodoTrouble',
    dependencies = 'nvim-lua/plenary.nvim',
    event = events.enter_buffer,
    keys = {
      { '[t',         function() require('todo-comments').jump_prev() end, desc = 'Previous TODO' },
      { ']t',         function() require('todo-comments').jump_next() end, desc = 'Next TODO' },
      { '<Leader>xt', '<Cmd>TodoTrouble<CR>',                              desc = 'Todo' },
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
    keys = { { '<Leader>um', function() require('codewindow').toggle_minimap() end, desc = 'Toggle Minimap' } },
    opts = {
      exclude_filetypes = require('utils.ui').excluded_filetypes,
      z_index = 50,
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
    config = config.which_key,
    event = 'VeryLazy',
  },
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        keys = {
          {
            '<Leader>un',
            function() require('notify').dismiss { silent = true, pending = true } end,
            desc = 'Dismiss all notifications',
          },
        },
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
  {
    'echasnovski/mini.indentscope',
    event = events.enter_buffer,
    init = config.indentscope,
    opts = {
      symbol = '│',
      options = { try_as_border = true },
    },
  },
  {
    'cbochs/portal.nvim',
    keys = {
      { '<C-o>', '<Cmd>Portal jumplist backward<CR>' },
      { '<C-i>', '<Cmd>Portal jumplist forward<CR>' },
    },
  },
}
