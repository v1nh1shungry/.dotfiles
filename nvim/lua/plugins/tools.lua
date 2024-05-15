local events = require('utils.events')

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
      { '<Leader>h', '<Cmd>Telescope help_tags<CR>', desc = 'Help pages' },
      { '<Leader>ff', '<Cmd>Telescope find_files<CR>', desc = 'Find files' },
      { '<Leader>fr', '<Cmd>Telescope oldfiles cwd_only=true<CR>', desc = 'Recent files' },
      { '<Leader>/', '<Cmd>Telescope live_grep<CR>', desc = 'Live grep' },
      { '<Leader>sa', '<Cmd>Telescope autocommands<CR>', desc = 'Autocommands' },
      { '<Leader>sk', '<Cmd>Telescope keymaps<CR>', desc = 'Keymaps' },
      { '<Leader>s@', '<Cmd>Telescope resume<CR>', desc = 'Last search' },
      { '<Leader>sh', '<Cmd>Telescope highlights<CR>', desc = 'Highlight groups' },
    },
    opts = {
      defaults = {
        prompt_prefix = '🔎 ',
        selection_caret = '➤ ',
        layout_strategy = 'bottom_pane',
        layout_config = {
          bottom_pane = {
            height = 0.4,
            preview_cutoff = 100,
            prompt_position = 'bottom',
          },
        },
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
        cmake = 'cmake',
        javascript = 'typescript',
        javascriptreact = 'typescript',
        json = 'json',
        lua = 'lua',
        markdown = 'markdown',
        python = 'python',
        typescript = 'typescript',
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
          augend.constant.new { elements = { 'let', 'const' } },
          ordinal_numbers,
          weekdays,
          months,
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
          augend.constant.new {
            elements = { 'and', 'or' },
            word = true,
            cyclic = true,
          },
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
        cmake = {
          augend.integer.alias.decimal,
          augend.semver.alias.semver,
          augend.constant.new {
            elements = { 'on', 'off' },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { 'ON', 'OFF' },
            word = true,
            cyclic = true,
          },
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
          nnoremap { '<Leader>gxo', '<Plug>(git-conflict-ours)', desc = 'Choose ours' }
          nnoremap { '<Leader>gxt', '<Plug>(git-conflict-theirs)', desc = 'Choose theirs' }
          nnoremap { '<Leader>gxb', '<Plug>(git-conflict-both)', desc = 'Choose both' }
          nnoremap { '<Leader>gx0', '<Plug>(git-conflict-none)', desc = 'Choose none' }
        end,
        pattern = 'GitConflictDetected',
      })
    end,
    dependencies = {
      'folke/which-key.nvim',
      optional = true,
      opts = { defaults = { ['<Leader>gx'] = { name = '+conflict' } } },
    },
    event = events.enter_buffer,
    opts = { default_mappings = false },
  },
  {
    'andrewferrier/debugprint.nvim',
    dependencies = {
      'folke/which-key.nvim',
      optional = true,
      opts = { defaults = { ['g?'] = { name = '+debugprint' } } },
    },
    keys = {
      'g?p',
      'g?P',
      { 'g?v', mode = { 'n', 'x' } },
      { 'g?V', mode = { 'n', 'x' } },
      'g?o',
      'g?O',
      'g?t',
      'g?d',
    },
    opts = {
      keymaps = {
        normal = {
          toggle_comment_debug_prints = 'g?t',
          delete_debug_prints = 'g?d',
        },
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewFileHistory', 'DiffviewOpen' },
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
          require('lazy').load { plugins = { 'cmake-tools.nvim' } }
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
      { '<Leader>mg', '<Cmd>CMakeGenerate<CR>', desc = 'Configure' },
      { '<Leader>mb', '<Cmd>CMakeBuild<CR>', desc = 'Build' },
      { '<Leader>mr', '<Cmd>CMakeRun<CR>', desc = 'Run executable' },
      { '<Leader>md', '<Cmd>CMakeDebug<CR>', desc = 'Debug' },
      { '<Leader>ma', ':CMakeLaunchArgs ', desc = 'Set launch arguments' },
      { '<Leader>ms', '<Cmd>CMakeTargetSettings<CR>', desc = 'Summary' },
    },
    opts = {
      cmake_generate_options = { '-G', 'Ninja', '-DCMAKE_EXPORT_COMPILE_COMMANDS=On' },
      cmake_soft_link_compile_commands = false,
      cmake_runner = { name = 'toggleterm' },
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
      '/',
      '?',
      'f',
      'F',
      't',
      'T',
      ',',
      ';',
      { 'gs', function() require('flash').jump() end, desc = 'Flash' },
      { 'gt', function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', function() require('flash').remote() end, mode = 'o', desc = 'Remote Flash' },
      {
        'R',
        function() require('flash').treesitter_search() end,
        mode = { 'o', 'x' },
        desc = 'Treesitter search',
      },
    },
    opts = {
      modes = {
        search = { enabled = false },
        char = { highlight = { backdrop = false } },
      },
      prompt = { enabled = false },
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
    'rhysd/committia.vim',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local inoremap = require('utils.keymaps').inoremap
          inoremap {
            '<M-d>',
            '<Plug>(committia-scroll-diff-down-half)',
            desc = 'Scroll down the diff window',
            buffer = args.buf,
          }
          inoremap {
            '<M-u>',
            '<Plug>(committia-scroll-diff-up-half)',
            desc = 'Scroll up the diff window',
            buffer = args.buf,
          }
        end,
        pattern = 'gitcommit',
      })
    end,
    event = 'BufReadPre COMMIT_EDITMSG',
  },
  {
    'HakonHarnes/img-clip.nvim',
    keys = { { '<Leader>fi', '<Cmd>PasteImage<CR>', desc = 'Paste image from clipboard' } },
  },
  {
    'kawre/leetcode.nvim',
    build = ':TSUpdate html',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-treesitter/nvim-treesitter',
      'rcarriga/nvim-notify',
      'nvim-tree/nvim-web-devicons',
    },
    lazy = vim.fn.argv()[1] ~= 'leetcode.nvim',
    opts = {
      cn = { enabled = true },
      injector = { cpp = { before = { '#include <bits/stdc++.h>', 'using namespace std;' } } },
    },
  },
  {
    'chrisgrieser/nvim-tinygit',
    ft = { 'git_rebase', 'gitcommit' },
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-telescope/telescope.nvim',
      'rcarriga/nvim-notify',
    },
    keys = {
      { '<Leader>gc', function() require('tinygit').smartCommit() end, desc = 'Commit' },
      { '<Leader>gP', function() require('tinygit').push() end, desc = 'Push' },
      { '<Leader>ga', function() require('tinygit').amendNoEdit() end, desc = 'Amend' },
      { '<Leader>gU', function() require('tinygit').undoLastCommit() end, desc = 'Undo last commit' },
    },
    opts = {},
  },
  {
    'gabrielpoca/replacer.nvim',
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          require('utils.keymaps').nnoremap {
            '<Leader>xr',
            function() require('replacer').run() end,
            desc = 'Quickfix replacer',
            buffer = args.buf,
          }
        end,
        pattern = 'qf',
      })
    end,
    ft = 'qf',
  },
  {
    'ThePrimeagen/refactoring.nvim',
    cmd = 'Refactor',
    keys = {
      {
        '<Leader>sR',
        function() require('refactoring').select_refactor() end,
        desc = 'Refactoring',
        mode = { 'n', 'x' },
      },
    },
    opts = {},
  },
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {
      disabled_filetypes = vim.list_extend({
        '',
        'alpha',
        'markdown',
        'text',
      }, require('utils.ui').excluded_filetypes),
    },
  },
  {
    'Myzel394/jsonfly.nvim',
    config = function()
      require('telescope').load_extension('jsonfly')
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          require('utils.keymaps').nnoremap {
            '<Leader>sj',
            '<Cmd>Telescope jsonfly<CR>',
            desc = 'Fly me to JSON',
            buffer = args.buf,
          }
        end,
        pattern = { 'json', 'jsonc' },
      })
    end,
    dependencies = 'nvim-telescope/telescope.nvim',
    ft = { 'json', 'jsonc' },
  },
  {
    'dhruvasagar/vim-table-mode',
    config = function()
      vim.g.table_mode_corner = '|'
      vim.g.table_mode_disable_mappings = 1
    end,
    keys = { { '<Leader>ft', '<Cmd>TableModeToggle<CR>', desc = 'Table mode' } },
  },
  {
    'v1nh1shungry/cppman.nvim',
    keys = { { '<Leader>sc', function() require('cppman').search() end, desc = 'Cppman' } },
    opts = {},
  },
  {
    'v1nh1shungry/biquge.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      {
        'folke/which-key.nvim',
        optional = true,
        opts = { defaults = { ['<Leader>b'] = { name = '+biquge' } } },
      },
    },
    keys = {
      { '<Leader>b/', function() require('biquge').search() end, desc = 'Search' },
      { '<Leader>bb', function() require('biquge').toggle() end, desc = 'Toggle' },
      { '<Leader>bt', function() require('biquge').toc() end, desc = 'TOC' },
      { '<Leader>bn', function() require('biquge').next_chap() end, desc = 'Next chapter' },
      { '<Leader>bp', function() require('biquge').prev_chap() end, desc = 'Previous chapter' },
      { '<Leader>bs', function() require('biquge').star() end, desc = 'Star current book' },
      { '<Leader>bl', function() require('biquge').bookshelf() end, desc = 'Bookshelf' },
      { '<M-d>', function() require('biquge').scroll(1) end, desc = 'Scroll down' },
      { '<M-u>', function() require('biquge').scroll(-1) end, desc = 'Scroll up' },
    },
    opts = { height = 5 },
  },
  {
    'nvim-telescope/telescope-symbols.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    keys = { { '<Leader>se', '<Cmd>Telescope symbols<CR>', desc = 'Emoji' } },
  },
}
