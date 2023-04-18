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
    keys = { { 'gS', '<Cmd>TSJSplit<CR>' }, { 'gJ', '<Cmd>TSJJoin<CR>' } },
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
    keys = { { 'gc', mode = { 'n', 'v' } } },
  },
  {
    'echasnovski/mini.surround',
    config = function(_, opts) require('mini.surround').setup(opts) end,
    keys = { { 'ys', mode = { 'n', 'x' } }, 'ds', 'cs' },
    opts = {
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
    'abecodes/tabout.nvim',
    config = config.tabout,
    event = events.enter_insert,
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    event = events.enter_buffer,
    opts = { useDefaultKeymaps = true, },
  },
  {
    'tiagovla/scope.nvim',
    config = true,
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
      { 'g*',    [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { 'g#',    [[g#<Cmd>lua require('hlslens').start()<CR>]] },
    },
  },
  {
    'tommcdo/vim-exchange',
    keys = { 'cx', { 'X', mode = 'v' } },
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
    keys = { { 'gr', mode = { 'n', 'v' } } },
  },
}
