local config = require('plugins.tools.config')
local events = require('utils.events')

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    config = config.telescope,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
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
    'metakirby5/codi.vim',
    cmd = 'Codi',
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
    'nvim-treesitter/playground',
    event = events.enter_buffer,
  },
  {
    'lambdalisue/suda.vim',
    cmd = { 'SudaEdit', 'SudaWrite' },
    config = function() vim.g['suda#nopass'] = true end,
  },
  'milisims/nvim-luaref',
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'sindrets/diffview.nvim',
        cmd = 'DiffviewOpen',
        dependencies = 'nvim-lua/plenary.nvim',
      },
    },
    opts = { signs = { section = { '', '' }, item = { '', '' } } },
  },
  {
    'phaazon/hop.nvim',
    config = true,
    keys = { { 'gs', '<Cmd>HopChar1<CR>' }, { 'gw', '<Cmd>HopWord<CR>' }, { 'gl', '<Cmd>HopLine<CR>' } },
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
}
