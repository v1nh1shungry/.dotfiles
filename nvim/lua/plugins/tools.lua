local events = require('utils.events')

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
      { '<Leader>h',  '<Cmd>Telescope help_tags<CR>',              desc = 'Help pages' },
      { '<Leader>ff', '<Cmd>Telescope find_files<CR>',             desc = 'Find files' },
      { '<Leader>fr', '<Cmd>Telescope oldfiles cwd_only=true<CR>', desc = 'Recent files' },
      { '<Leader>/',  '<Cmd>Telescope live_grep<CR>',              desc = 'Live grep' },
      { '<Leader>sa', '<Cmd>Telescope autocommands<CR>',           desc = 'Autocommands' },
      { '<Leader>:',  '<Cmd>Telescope commands<CR>',               desc = 'Commands' },
      { '<Leader>sk', '<Cmd>Telescope keymaps<CR>',                desc = 'Keymaps' },
      { '<Leader>g/', '<Cmd>Telescope git_commits<CR>',            desc = 'Commits' },
      { '<Leader>sb', '<Cmd>Telescope buffers<CR>',                desc = 'Switch buffer' },
      { '<Leader>sl', '<Cmd>Telescope resume<CR>',                 desc = 'Last search' },
      { "<Leader>s'", '<Cmd>Telescope marks<CR>',                  desc = 'Marks' },
      { '<Leader>s"', '<Cmd>Telescope registers<CR>',              desc = 'Registers' },
      { '<Leader>sh', '<Cmd>Telescope highlights<CR>',             desc = 'Highlight groups' },
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
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>',  '<Plug>(dial-increment)',  mode = { 'n', 'v' }, desc = 'Increment' },
      { '<C-x>',  '<Plug>(dial-decrement)',  mode = { 'n', 'v' }, desc = 'Decrement' },
      { 'g<C-a>', 'g<Plug>(dial-increment)', mode = { 'n', 'v' }, desc = 'Increment' },
      { 'g<C-x>', 'g<Plug>(dial-decrement)', mode = { 'n', 'v' }, desc = 'Decrement' },
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
    'cshuaimin/ssr.nvim',
    keys = { { '<Leader>sr', function() require('ssr').open() end, mode = { 'n', 'x' }, desc = 'Structural replace' } },
  },
  {
    'akinsho/git-conflict.nvim',
    config = function(_, opts)
      require('git-conflict').setup(opts)
      vim.api.nvim_create_autocmd('User', {
        callback = function(args)
          local nnoremap = function(key)
            key.buffer = args.buf
            require('utils.keymaps').nnoremap(key)
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
  {
    'sindrets/diffview.nvim',
    keys = { { '<Leader>gD', '<Cmd>DiffviewOpen<CR>', desc = 'Open git diff pane' } },
  },
  {
    'Civitasv/cmake-tools.nvim',
    dependencies = {
      'folke/which-key.nvim',
      optional = true,
      opts = { defaults = { ['<Leader>m'] = { name = '+cmake' } } },
    },
    keys = {
      { '<Leader>mg', '<Cmd>CMakeGenerate<CR>',       desc = 'Configure' },
      { '<Leader>mb', '<Cmd>CMakeBuild<CR>',          desc = 'Build' },
      { '<Leader>mr', '<Cmd>CMakeRun<CR>',            desc = 'Run executable' },
      { '<Leader>md', '<Cmd>CMakeDebug<CR>',          desc = 'Debug' },
      { '<Leader>ma', ':CMakeLaunchArgs ',            desc = 'Set launch arguments' },
      { '<Leader>ms', '<Cmd>CMakeTargetSettings<CR>', desc = 'Summary' },
    },
    opts = {
      cmake_generate_options = { '-G', 'Ninja', '-DCMAKE_EXPORT_COMPILE_COMMANDS=On' },
      cmake_build_directory = 'build',
      cmake_soft_link_compile_commands = false,
      cmake_terminal = {
        opts = {
          start_insert_in_launch_task = true,
          focus_on_launch_terminal = true,
        },
      },
    },
  },
  {
    'johmsalas/text-case.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    keys = '<Leader>cc',
    opts = { prefix = '<Leader>cc' },
  },
  {
    'folke/flash.nvim',
    keys = {
      '/', '?', 'f', 'F', 't', 'T', ',', ';',
      { 'gs', function() require('flash').jump() end,              desc = 'Flash' },
      { 'gt', function() require('flash').treesitter() end,        desc = 'Flash Treesitter' },
      { 'r',  function() require('flash').remote() end,            mode = 'o',               desc = 'Remote Flash' },
      { 'R',  function() require('flash').treesitter_search() end, mode = { 'o', 'x' },      desc = 'Treesitter search' },
    },
    opts = {
      modes = {
        search = { enabled = false },
        char = { highlight = { backdrop = false } },
      },
    },
  },
  {
    'nvim-pack/nvim-spectre',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = { { '<Leader>sd', '<Cmd>Spectre<CR>', desc = 'Spectre' } },
  },
  {
    'echasnovski/mini.files',
    keys = { { '<Leader>fe', '<Cmd>lua MiniFiles.open()<CR>', desc = 'Filesystem buffer' } },
    opts = { options = { use_as_default_explorer = false } },
  },
  {
    'debugloop/telescope-undo.nvim',
    config = function() require('telescope').load_extension('undo') end,
    dependencies = 'nvim-telescope/telescope.nvim',
    keys = { { '<Leader>ut', '<Cmd>Telescope undo<CR>', desc = 'Undotree' } },
  },
  {
    'rhysd/committia.vim',
    event = 'BufReadPre COMMIT_EDITMSG',
  },
}
