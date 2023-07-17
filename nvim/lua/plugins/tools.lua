local events = require('utils.events')

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
      { '<Leader>h',  '<Cmd>Telescope help_tags<CR>',   desc = 'Help pages' },
      { '<Leader>ff', '<Cmd>Telescope find_files<CR>',  desc = 'Find files' },
      { '<Leader>fo', '<Cmd>Telescope oldfiles<CR>',    desc = 'Recent files' },
      { '<Leader>/',  '<Cmd>Telescope live_grep<CR>',   desc = 'Live grep' },
      { '<Leader>sm', '<Cmd>Telescope man_pages<CR>',   desc = 'Man pages' },
      { '<Leader>:',  '<Cmd>Telescope commands<CR>',    desc = 'Commands' },
      { '<Leader>sk', '<Cmd>Telescope keymaps<CR>',     desc = 'Keymaps' },
      { '<Leader>g/', '<Cmd>Telescope git_commits<CR>', desc = 'Git commits' },
      { '<Leader>,',  '<Cmd>Telescope buffers<CR>',     desc = 'Switch buffer' },
      { '<Leader>sl', '<Cmd>Telescope resume<CR>',      desc = 'Last search' },
    },
    opts = {
      defaults = {
        prompt_prefix = '🔎 ',
        selection_caret = '➤ ',
      },
    },
  },
  {
    'krady21/compiler-explorer.nvim',
    cmd = { 'CECompile', 'CECompileLive' },
    dependencies = 'stevearc/dressing.nvim',
  },
  {
    'skywind3000/asynctasks.vim',
    config = function()
      vim.g.asyncrun_open = 10
      vim.g.asynctasks_term_rows = 10
      vim.g.asynctasks_term_pos = 'bottom'
    end,
    dependencies = {
      'skywind3000/asyncrun.vim',
      cmd = 'AsyncRun',
    },
    keys = {
      { '<Leader>fb', '<Cmd>AsyncTask file-build<CR>', desc = 'Build' },
      { '<Leader>fr', '<Cmd>AsyncTask file-run<CR>',   desc = 'Run' },
    },
  },
  {
    'sQVe/sort.nvim',
    cmd = 'Sort',
  },
  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', '<Plug>(dial-increment)', mode = { 'n', 'v' } },
      { '<C-x>', '<Plug>(dial-decrement)', mode = { 'n', 'v' } },
    },
  },
  {
    'danymat/neogen',
    opts = { snippet_engine = 'luasnip' },
    keys = { { '<Leader>cg', '<Cmd>Neogen<CR>', desc = 'Generate document comment' } },
  },
  {
    'echasnovski/mini.align',
    config = function() require('mini.align').setup() end,
    keys = {
      { 'ga', mode = { 'n', 'x' }, desc = 'Align' },
      { 'gA', mode = { 'n', 'x' }, desc = 'Align with preview' },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    ft = 'markdown',
  },
  {
    'RRethy/nvim-treesitter-endwise',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = events.enter_insert,
  },
  {
    'roobert/search-replace.nvim',
    config = true,
    keys = {
      { '<Leader>sr', '<Cmd>SearchReplaceSingleBufferCWord<CR>',           desc = 'Search and replace' },
      { '<Leader>sr', '<Cmd>SearchReplaceSingleBufferVisualSelection<CR>', desc = 'Search and replace', mode = 'v' },
    },
  },
  {
    'tommcdo/vim-exchange',
    keys = { { 'cx', desc = 'Exchange' }, { 'X', mode = 'v' } },
  },
  {
    'vim-scripts/ReplaceWithRegister',
    keys = { { 'gr', mode = { 'n', 'v' }, desc = 'Replace with register' } },
  },
  {
    'cshuaimin/ssr.nvim',
    keys = { { '<Leader>sR', function() require('ssr').open() end, mode = { 'n', 'x' }, desc = 'Structural replace' } },
  },
  {
    'NeogitOrg/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = { { '<Leader>gm', '<Cmd>Neogit<CR>', desc = 'Magit' } },
    opts = {
      disable_commit_confirmation = true, -- compatible with `noice.nvim`
      signs = { section = { '', '' }, item = { '', '' } },
    },
  },
  {
    'akinsho/git-conflict.nvim',
    config = function(_, opts)
      require('git-conflict').setup(opts)
      vim.api.nvim_create_autocmd('User', {
        callback = function(args)
          local nnoremap = function(key)
            require('utils.keymaps').nnoremap(vim.tbl_extend('keep', key, { buffer = args.buf }))
          end
          nnoremap { '<Leader>gco', '<Plug>(git-conflict-ours)', desc = 'Choose ours' }
          nnoremap { '<Leader>gct', '<Plug>(git-conflict-theirs)', desc = 'Choose theirs' }
          nnoremap { '<Leader>gcb', '<Plug>(git-conflict-both)', desc = 'Choose both' }
          nnoremap { '<Leader>gc0', '<Plug>(git-conflict-none)', desc = 'Choose none' }
        end,
        pattern = 'GitConflictDetected',
      })
    end,
    dependencies = {
      'folke/which-key.nvim',
      optional = true,
      opts = { defaults = { ['<Leader>gc'] = { name = '+conflict' } } },
    },
    event = events.enter_buffer,
    opts = { default_mappings = false },
  },
  {
    'andrewferrier/debugprint.nvim',
    dependencies = {
      'folke/which-key.nvim',
      optional = true,
      opts = { defaults = { ['<Leader>dp'] = { name = '+print' } } },
    },
    keys = {
      {
        '<Leader>dpp',
        function() return require('debugprint').debugprint() end,
        desc = 'Print below',
        expr = true,
      },
      {
        '<Leader>dpP',
        function() return require('debugprint').debugprint({ above = true }) end,
        desc = 'Print above',
        expr = true,
      },
      {
        '<Leader>dpv',
        function() return require('debugprint').debugprint({ variable = true }) end,
        desc = 'Print variable below',
        expr = true,
        mode = { 'n', 'v' },
      },
      {
        '<Leader>dpV',
        function() return require('debugprint').debugprint({ above = true, variable = true }) end,
        desc = 'Print variable above',
        expr = true,
        mode = { 'n', 'v' },
      },
    },
    opts = { create_keymaps = false, create_commands = false },
  },
}
