local config = require('plugins.core.config')
local events = require('utils.events')

return {
  {
    'andymass/vim-matchup',
    config = function() vim.g.matchup_matchparen_offscreen = { method = '' } end,
    event = events.enter_buffer,
  },
  {
    'tpope/vim-unimpaired',
    keys = { '[', ']' },
  },
  {
    'tpope/vim-sleuth',
    event = events.enter_buffer,
  },
  {
    'wellle/targets.vim',
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
    keys = { { 'gS', '<Cmd>TSJSplit<CR>' }, { 'gJ', '<Cmd>TSJJoin<CR>' } },
  },
  {
    'RRethy/nvim-treesitter-endwise',
    event = events.enter_insert,
  },
  {
    'ethanholz/nvim-lastplace',
    config = true,
    event = events.enter_buffer,
  },
  {
    'rhysd/clever-f.vim',
    keys = {
      { 'f', mode = { 'n', 'x' } },
      { 'F', mode = { 'n', 'x' } },
      { 't', mode = { 'n', 'x' } },
      { 'T', mode = { 'n', 'x' } },
      { ';', '<Plug>(clever-f-repeat-forward)', mode = { 'n', 'x' } },
      { ',', '<Plug>(clever-f-repeat-back)',    mode = { 'n', 'x' } },
    },
  },
  {
    'RRethy/vim-illuminate',
    config = function() require('illuminate').configure { providers = { 'lsp', 'treesitter' } } end,
    event = events.enter_buffer,
  },
  {
    'romainl/vim-cool',
    keys = { '/', '?', '*', '#', 'g*', 'g#', 'n', 'N' },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = events.enter_buffer,
    opts = config.indent_blankline,
  },
  {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
    keys = { { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' } } },
  },
  {
    'numToStr/Comment.nvim',
    config = true,
    keys = { { 'gc', mode = { 'n', 'v' } } },
  },
  {
    'kylechui/nvim-surround',
    config = true,
    keys = { 'ys', 'yS', 'cs', 'cS', 'ds', 'dS', { 's', mode = 'x' }, { 'S', mode = 'x' } },
  },
  {
    'mg979/vim-visual-multi',
    keys = { { '<C-n>', mode = { 'n', 'v' } } },
  },
  {
    'tpope/vim-rsi',
    event = events.enter_insert,
  },
  {
    'windwp/nvim-autopairs',
    config = config.autopairs,
    event = events.enter_insert,
  },
  {
    'abecodes/tabout.nvim',
    config = config.tabout,
    event = events.enter_insert,
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    event = events.enter_buffer,
  },
  {
    'kana/vim-operator-replace',
    dependencies = 'kana/vim-operator-user',
    keys = { { 'gr', '<Plug>(operator-replace)' } },
  },
  {
    'tiagovla/scope.nvim',
    config = true,
    event = 'TabNew',
  },
}
