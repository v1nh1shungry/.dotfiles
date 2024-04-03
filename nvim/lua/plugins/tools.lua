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
    config = function()
      local augend = require('dial.augend')
      local map = require('utils.keymaps').noremap

      local dials_by_ft = {
        css = 'css',
        javascript = 'typescript',
        javascriptreact = 'typescript',
        json = 'json',
        lua = 'lua',
        markdown = 'markdown',
        python = 'python',
        sass = 'css',
        scss = 'css',
        typescript = 'typescript',
        typescriptreact = 'typescript',
      }

      local dial = function(increment, g)
        local is_visual = vim.fn.mode(true):sub(1, 1) == 'v'
        local func = (increment and 'inc' or 'dec') .. (g and '_g' or '_') .. (is_visual and 'visual' or 'normal')
        local group = dials_by_ft[vim.bo.filetype] or 'default'
        return require('dial.map')[func](group)
      end

      local logical_alias = augend.constant.new {
        elements = { '&&', '||' },
        word = false,
        cyclic = true,
      }

      local ordinal_numbers = augend.constant.new {
        elements = {
          'first',
          'second',
          'third',
          'fourth',
          'fifth',
          'sixth',
          'seventh',
          'eighth',
          'ninth',
          'tenth',
        },
        word = false,
        cyclic = true,
      }

      local weekdays = augend.constant.new {
        elements = {
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        },
        word = true,
        cyclic = true,
      }

      local months = augend.constant.new {
        elements = {
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        },
        word = true,
        cyclic = true,
      }

      local capitalized_boolean = augend.constant.new {
        elements = {
          'True',
          'False',
        },
        word = true,
        cyclic = true,
      }

      local groups = {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
        },
        typescript = {
          augend.integer.alias.decimal,
          augend.constant.alias.bool,
          logical_alias,
          augend.constant.new({ elements = { 'let', 'const' } }),
          ordinal_numbers,
          weekdays,
          months,
        },
        css = {
          augend.integer.alias.decimal,
          augend.hexcolor.new({
            case = 'lower',
          }),
          augend.hexcolor.new({
            case = 'upper',
          }),
        },
        markdown = {
          augend.misc.alias.markdown_header,
          ordinal_numbers,
          weekdays,
          months,
        },
        json = {
          augend.integer.alias.decimal,
          augend.semver.alias.semver,
        },
        lua = {
          augend.integer.alias.decimal,
          augend.constant.alias.bool,
          augend.constant.new({
            elements = { 'and', 'or' },
            word = true,
            cyclic = true,
          }),
          ordinal_numbers,
          weekdays,
          months,
        },
        python = {
          augend.integer.alias.decimal,
          capitalized_boolean,
          logical_alias,
          ordinal_numbers,
          weekdays,
          months,
        },
      }

      require('dial.config').augends:register_group(groups)

      map { '<C-a>', function() return dial(true) end, expr = true, mode = { 'n', 'v' } }
      map { '<C-x>', function() return dial(false) end, expr = true, mode = { 'n', 'v' } }
      map { 'g<C-a>', function() return dial(true, true) end, expr = true, mode = { 'n', 'v' } }
      map { 'g<C-x>', function() return dial(false, true) end, expr = true, mode = { 'n', 'v' } }
    end,
    keys = {
      { '<C-a>', desc = 'Increment' },
      { '<C-x>', desc = 'Decrement' },
      { 'g<C-a>', desc = 'Increment' },
      { 'g<C-x>', desc = 'Decrement' },
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
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1 then
          require('lazy').load({ plugins = { 'cmake-tools.nvim' } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd('DirChanged', {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    keys = {
      { '<Leader>mg', '<Cmd>CMakeGenerate<CR>',       desc = 'Configure' },
      { '<Leader>mb', '<Cmd>CMakeBuild<CR>',          desc = 'Build' },
      { '<Leader>mr', '<Cmd>CMakeRun<CR>',            desc = 'Run executable' },
      { '<Leader>md', '<Cmd>CMakeDebug<CR>',          desc = 'Debug' },
      { '<Leader>ma', ':CMakeLaunchArgs ',            desc = 'Set launch arguments' },
      { '<Leader>ms', '<Cmd>CMakeTargetSettings<CR>', desc = 'Summary' },
    },
    lazy = true,
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
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    keys = { { '<Leader>fi', '<Cmd>PasteImage<CR>', desc = 'Paste image from clipboard' } },
  },
  {
    'chrisgrieser/nvim-scissors',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      {
        'folke/which-key.nvim',
        optional = true,
        opts = { defaults = { ['<Leader>cs'] = { name = '+snippet' } } },
      },
    },
    keys = {
      { '<Leader>cse', function() require('scissors').editSnippet() end,   desc = 'Edit existing snippet' },
      { '<Leader>csa', function() require('scissors').addNewSnippet() end, mode = { 'n', 'x' },           desc = 'Add new snippet' },
    },
  },
}
