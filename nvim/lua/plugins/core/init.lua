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
      { 'gS', '<Cmd>TSJSplit<CR>', desc = 'Treesj Split' },
      { 'gJ', '<Cmd>TSJJoin<CR>',  desc = 'Treesj Join' },
    },
  },
  {
    'RRethy/vim-illuminate',
    config = function() require('illuminate').configure { providers = { 'lsp', 'treesitter' } } end,
    event = events.enter_buffer,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = events.enter_buffer,
    opts = { show_trailing_blankline_indent = false, show_current_context = true },
  },
  {
    'numToStr/Comment.nvim',
    config = true,
    keys = { { 'gc', mode = { 'n', 'v' }, desc = 'Toggle comment' } },
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
    'tommcdo/vim-exchange',
    keys = { { 'cx', desc = 'Exchange' }, { 'X', mode = 'v' } },
  },
  {
    'LunarVim/bigfile.nvim',
    event = events.enter_buffer,
  },
  {
    'keaising/im-select.nvim',
    config = true,
    event = events.enter_insert,
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
    'vim-scripts/ReplaceWithRegister',
    keys = { { 'gr', mode = { 'n', 'v' }, desc = 'Replace with register' } },
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    event = events.enter_buffer,
    opts = { useDefaultKeymaps = true },
  },
  {
    'tpope/vim-rsi',
    event = events.enter_insert,
  },
}
