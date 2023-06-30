local config = require('plugins.core.config')
local events = require('utils.events')

return {
  {
    'andymass/vim-matchup',
    config = function() vim.g.matchup_matchparen_offscreen = { method = '' } end,
    event = events.enter_buffer,
  },
  {
    'echasnovski/mini.bracketed',
    config = config.bracketed,
    keys = { '[', ']' },
  },
  {
    'nmac427/guess-indent.nvim',
    config = true,
    event = events.enter_buffer,
  },
  {
    'echasnovski/mini.ai',
    config = function() require('mini.ai').setup() end,
    event = events.enter_buffer,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = config.treesitter,
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    event = events.enter_buffer,
  },
  {
    'Wansmer/treesj',
    config = true,
    keys = {
      { 'S', '<Cmd>TSJSplit<CR>', desc = 'Treesj Split' },
      { 'J', '<Cmd>TSJJoin<CR>',  desc = 'Treesj Join' },
    },
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
      show_current_context = true,
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
    config = config.surround,
    keys = {
      { 'ys', desc = 'Add surrounding' },
      { 'ds', desc = 'Delete surrounding' },
      { 'cs', desc = 'Change surrounding' },
      { 'S',  mode = 'x' },
    },
  },
  {
    'mg979/vim-visual-multi',
    config = config.visual_multi,
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
    'tommcdo/vim-exchange',
    keys = { { 'cx', desc = 'Exchange' }, { 'X', mode = 'v' } },
  },
  {
    'LunarVim/bigfile.nvim',
    event = events.enter_buffer,
  },
  {
    'vim-scripts/ReplaceWithRegister',
    keys = { { 'gr', mode = { 'n', 'v' }, desc = 'Replace with register' } },
  },
  {
    'axkirillov/hbac.nvim',
    opts = { threshold = 5 },
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
}
