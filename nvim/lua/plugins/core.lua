local events = require('utils.events')

return {
  {
    'utilyre/sentiment.nvim',
    config = true,
    dependencies = {
      'andymass/vim-matchup',
      config = function() vim.g.matchup_matchparen_offscreen = { method = '' } end,
    },
    event = events.enter_buffer,
    init = function() vim.g.loaded_matchparen = 1 end,
  },
  {
    'nmac427/guess-indent.nvim',
    config = true,
    event = events.enter_buffer,
  },
  {
    'echasnovski/mini.ai',
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    event = events.enter_buffer,
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
    event = events.enter_buffer,
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cpp',
        'fish',
        'json',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'query',
        'vimdoc',
      },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-Space>',
          node_incremental = '<C-Space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      matchup = { enable = true },
      textobjects = {
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
          },
          goto_next_end = {
            [']F'] = '@function.outer',
          },
          goto_previous_start = {
            ['[a'] = '@parameter.inner',
            ['[f'] = '@function.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
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
      show_current_context = true,
    },
  },
  {
    'echasnovski/mini.comment',
    config = true,
    keys = { { 'gc', mode = { 'n', 'v' }, desc = 'Toggle comment' } },
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
    keys = {
      '/', '?', 'f', 'F', 't', 'T',
      { 'gs', function() require('flash').jump() end,              desc = 'Flash' },
      { 'gS', function() require('flash').treesitter() end,        desc = 'Flash Treesitter' },
      { 'r',  function() require('flash').remote() end,            mode = 'o',               desc = 'Remote Flash' },
      { 'R',  function() require('flash').treesitter_search() end, mode = { 'o', 'x' },      desc = 'Treesitter search' },
    },
    opts = { modes = { search = { enabled = false } } },
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
  {
    'willothy/flatten.nvim',
    opts = { window = { open = 'alternate' } },
  },
}
