local events = require('utils.events')

return {
  {
    'andymass/vim-matchup',
    config = function() vim.g.matchup_matchparen_offscreen = { method = '' } end,
    event = events.enter_buffer,
  },
  {
    'echasnovski/mini.bracketed',
    keys = { '[', ']' },
    opts = {
      comment = { suffix = '' },
      diagnostic = { suffix = '' },
      file = { suffix = '' },
    },
  },
  {
    'nmac427/guess-indent.nvim',
    config = true,
    event = events.enter_buffer,
  },
  {
    'echasnovski/mini.ai',
    config = true,
    event = events.enter_buffer,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    event = events.enter_buffer,
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cpp',
        'fish',
        'haskell',
        'javascript',
        'json',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'rust',
        'toml',
        'typescript',
        'vimdoc',
        'yaml',
      },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      matchup = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['ic'] = '@class.inner',
            ['ac'] = '@class.outer',
            ['if'] = '@function.inner',
            ['af'] = '@function.outer',
            ['ia'] = '@parameter.inner',
            ['aa'] = '@parameter.outer',
            ['as'] = '@statement.outer',
            ['al'] = '@assignment.lhs',
            ['ar'] = '@assignment.rhs',
          },
        },
        swap = {
          enable = true,
          swap_next = { ['<M-l>'] = '@parameter.inner' },
          swap_previous = { ['<M-h>'] = '@parameter.inner' },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']a'] = '@parameter.inner',
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@class.outer',
          },
          goto_previous_start = {
            ['[a'] = '@parameter.inner',
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@class.outer',
          },
        },
      },
      endwise = { enable = true },
      rainbow = { enable = true },
    },
  },
  {
    'Wansmer/treesj',
    config = true,
    keys = { { 'S', '<Cmd>TSJSplit<CR>' }, { 'J', '<Cmd>TSJJoin<CR>' } },
  },
  {
    'RRethy/vim-illuminate',
    config = function() require('illuminate').configure { providers = { 'lsp', 'treesitter' } } end,
    event = events.enter_buffer,
    keys = {
      { '[[', function() require('illuminate').goto_prev_reference(false) end, desc = 'Previous reference' },
      { ']]', function() require('illuminate').goto_next_reference(false) end, desc = 'Next reference' },
    }
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = events.enter_buffer,
    opts = {
      show_trailing_blankline_indent = false,
      filetype_exclude = require('utils.ui').excluded_filetypes,
    },
  },
  {
    'numToStr/Comment.nvim',
    config = true,
    keys = {
      { 'gc',    mode = { 'n', 'v' },                             desc = 'Toggle comment' },
      { '<C-_>', '<ESC><Plug>(comment_toggle_linewise_current)i', mode = 'i' },
    },
  },
  {
    'echasnovski/mini.surround',
    config = function()
      require('mini.surround').setup {
        mappings = {
          add = 'ys',
          delete = 'ds',
          find = '',
          find_left = '',
          highlight = '',
          replace = 'cs',
          update_n_lines = '',
          suffix_last = '',
          suffix_next = '',
        },
        search_method = 'cover_or_next',
      }
      vim.keymap.del('x', 'ys')
    end,
    keys = {
      { 'ys',  desc = 'Add surrounding' },
      { 'ds',  desc = 'Delete surrounding' },
      { 'cs',  desc = 'Change surrounding' },
      { 'S',   [[:<C-u>lua MiniSurround.add('visual')<CR>]], mode = 'x' },
      { 'yss', 'ys_',                                        remap = true },
    },
  },
  {
    'mg979/vim-visual-multi',
    config = function()
      vim.g.VM_silent_exit = true
      vim.g.VM_set_statusline = 0
      vim.g.VM_quit_after_leaving_insert_mode = true
      vim.g.VM_show_warnings = 0
    end,
    keys = { { '<C-n>', mode = { 'n', 'v' } } },
  },
  {
    'altermo/ultimate-autopair.nvim',
    event = events.enter_insert,
    opts = { cr = { addsemi = {} } },
  },
  {
    'tiagovla/scope.nvim',
    config = true,
    event = 'VeryLazy',
  },
  {
    'LunarVim/bigfile.nvim',
    event = events.enter_buffer,
  },
  {
    'folke/flash.nvim',
    config = true,
    keys = {
      '/', '?', 'f', 'F', 't', 'T',
      { 'gs', function() require('flash').jump() end,       desc = 'Flash' },
      { 'gt', function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r',  function() require('flash').remote() end,     mode = 'o',               desc = 'Remote Flash' },
    },
  },
  {
    'm4xshen/hardtime.nvim',
    event = 'VeryLazy',
    opts = {
      disabled_filetypes = require('utils.ui').excluded_filetypes, -- Yep, this is not relevant to `UI` at all, but it just works :)
      notification = false,
    },
  },
  {
    'chrisgrieser/nvim-spider',
    keys = {
      { 'w',  "<Cmd>lua require('spider').motion('w')<CR>",  mode = { 'n', 'o', 'x' } },
      { 'e',  "<Cmd>lua require('spider').motion('e')<CR>",  mode = { 'n', 'o', 'x' } },
      { 'b',  "<Cmd>lua require('spider').motion('b')<CR>",  mode = { 'n', 'o', 'x' } },
      { 'ge', "<Cmd>lua require('spider').motion('ge')<CR>", mode = { 'n', 'o', 'x' } },
    },
  },
}
