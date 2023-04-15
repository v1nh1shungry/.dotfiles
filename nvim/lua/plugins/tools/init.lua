local config = require('plugins.tools.config')

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    config = config.telescope,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
    },
    keys = { { '<Leader>h', '<Cmd>Telescope help_tags<CR>' }, { '<C-p>', '<Cmd>Telescope find_files<CR>' } },
  },
  {
    'krady21/compiler-explorer.nvim',
    cmd = { 'CECompile', 'CECompileLive' },
    dependencies = 'stevearc/dressing.nvim',
  },
  {
    'skywind3000/asynctasks.vim',
    cmd = { 'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit' },
    config = config.asynctasks,
    dependencies = {
      'skywind3000/asyncrun.vim',
      cmd = 'AsyncRun',
    },
    keys = { { '<Leader>fb', '<Cmd>AsyncTask file-build<CR>' }, { '<Leader>fr', '<Cmd>AsyncTask file-run<CR>' } },
  },
  {
    'sQVe/sort.nvim',
    cmd = 'Sort',
  },
  {
    'tpope/vim-eunuch',
    cmd = { 'Delete', 'Rename' },
    config = config.eunuch,
  },
  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', '<Plug>(dial-increment)', mode = { 'n', 'v' } },
      { '<C-x>', '<Plug>(dial-decrement)', mode = { 'n', 'v' } },
    },
  },
  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModeToggle',
    config = function() vim.g.table_mode_corner = '|' end,
    keys = '<Leader>tm',
  },
  {
    'danymat/neogen',
    cmd = 'Neogen',
    opts = { snippet_engine = 'luasnip' },
  },
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    opts = { signs = { section = { '', '' }, item = { '', '' } } },
  },
  {
    'roobert/search-replace.nvim',
    config = true,
    keys = {
      { '<Leader>rw', '<Cmd>SearchReplaceSingleBufferCWord<CR>' },
      { '<C-r>', '<Cmd>SearchReplaceSingleBufferVisualSelection<CR>', mode = 'v' },
    },
  },
  {
    'AckslD/nvim-FeMaco.lua',
    config = true,
    cmd = 'FeMaco',
  },
  {
    'cbochs/portal.nvim',
    keys = {
      { '<C-o>', '<Cmd>Portal jumplist backward<CR>' },
      { '<C-i>', '<Cmd>Portal jumplist forward<CR>' },
    },
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Gvdiffsplit', 'GDelete' },
  },
  {
    'cshuaimin/ssr.nvim',
    keys = { { '<Leader>sr', function() require('ssr').open() end, mode = { 'n', 'x' } } },
  },
  {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
    keys = { { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' } } },
  },
  {
    'gaoDean/autolist.nvim',
    config = config.autolist,
    event = require('utils.events').enter_insert,
  },
  {
    'Civitasv/cmake-tools.nvim',
    cmd = 'CMakeGenerate',
    opts = { cmake_build_directory = 'build' },
  },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
  },
  {
    'phaazon/hop.nvim',
    config = true,
    keys = { { 'gs', '<Cmd>HopChar1<CR>', mode = { 'n', 'x' } } },
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    ft = 'markdown',
  },
}
