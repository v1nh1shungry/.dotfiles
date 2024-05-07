local events = require('utils.events')

return {
  {
    'andymass/vim-matchup',
    config = function() vim.g.matchup_matchparen_offscreen = { method = '' } end,
    event = events.enter_buffer,
  },
  {
    'nmac427/guess-indent.nvim',
    opts = {},
  },
  {
    'echasnovski/mini.ai',
    config = function(_, opts)
      require('mini.ai').setup(opts)
      local i = {
        [' '] = 'Whitespace',
        ['"'] = 'Balanced "',
        ["'"] = "Balanced '",
        ['`'] = 'Balanced `',
        ['('] = 'Balanced (',
        [')'] = 'Balanced ) including white-space',
        ['>'] = 'Balanced > including white-space',
        ['<lt>'] = 'Balanced <',
        [']'] = 'Balanced ] including white-space',
        ['['] = 'Balanced [',
        ['}'] = 'Balanced } including white-space',
        ['{'] = 'Balanced {',
        ['?'] = 'User Prompt',
        _ = 'Underscore',
        a = 'Argument',
        b = 'Balanced ), ], }',
        c = 'Class',
        d = 'Digit(s)',
        f = 'Function',
        g = 'Entire file',
        o = 'Block, conditional, loop',
        q = 'Quote `, ", \'',
        t = 'Tag',
        u = 'Use/call function & method',
        U = 'Use/call without dot in name',
      }
      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(' including.*', '')
      end
      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs { n = 'Next', l = 'Last' } do
        i[key] = vim.tbl_extend('force', { name = 'Inside ' .. name .. ' textobject' }, ic)
        a[key] = vim.tbl_extend('force', { name = 'Around ' .. name .. ' textobject' }, ac)
      end
      require('which-key').register {
        mode = { 'o', 'x' },
        i = i,
        a = a,
      }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      config = function(_, opts)
        local move = require('nvim-treesitter.textobjects.move')
        local configs = require('nvim-treesitter.configs')
        for name, fn in pairs(move) do
          if name:find('goto') == 1 then
            move[name] = function(q, ...)
              if vim.wo.diff then
                local config = configs.get_module('textobjects.move')[name]
                for key, query in pairs(config or {}) do
                  if q == query and key:find('[%]%[][cC]') then
                    vim.cmd('normal! ' .. key)
                    return
                  end
                end
              end
              return fn(q, ...)
            end
          end
        end
        configs.setup(opts)
      end,
      dependencies = 'nvim-treesitter/nvim-treesitter',
      opts = {
        textobjects = {
          swap = { enable = false },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']a'] = '@parameter.inner',
              [']f'] = '@function.outer',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
            },
            goto_previous_start = {
              ['[a'] = '@parameter.inner',
              ['[f'] = '@function.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
            },
          },
        },
      },
    },
    event = events.enter_buffer,
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
          d = { '%f[%d]%d+' },
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line('$'),
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call { name_pattern = '[%w_]' },
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = events.enter_buffer,
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cpp',
        'doxygen',
        'fish',
        'git_rebase',
        'gitcommit',
        'html',
        'json',
        'jsonc',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'query',
        'regex',
        'vim',
        'vimdoc',
      },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-Space>',
          node_incremental = '<C-Space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      indent = { enable = true },
      matchup = { enable = true },
    },
  },
  {
    'Wansmer/treesj',
    keys = {
      { 'S', '<Cmd>TSJSplit<CR>', desc = 'Split line' },
      { 'J', '<Cmd>TSJJoin<CR>', desc = 'Join line' },
    },
    opts = { use_default_keymaps = false },
  },
  {
    'RRethy/vim-illuminate',
    config = function() require('illuminate').configure { providers = { 'lsp', 'treesitter' } } end,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = events.enter_buffer,
    keys = {
      { '[[', function() require('illuminate').goto_prev_reference(false) end, desc = 'Previous reference' },
      { ']]', function() require('illuminate').goto_next_reference(false) end, desc = 'Next reference' },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function(_, opts)
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = '#56B6C2' })
      end)
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      require('ibl').setup(opts)
    end,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = events.enter_buffer,
    opts = {
      indent = { char = '│', tab_char = '│' },
      scope = {
        show_start = false,
        show_end = false,
        include = { node_type = { lua = { 'table_constructor' } } },
        highlight = require('utils.ui').rainbow_highlight,
      },
      exclude = { filetypes = require('utils.ui').excluded_filetypes },
    },
  },
  {
    'echasnovski/mini.surround',
    config = function()
      require('mini.surround').setup {
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
      }
      vim.keymap.del('x', 'ys')
    end,
    keys = {
      { 'ys', desc = 'Add surrounding' },
      { 'ds', desc = 'Delete surrounding' },
      { 'cs', desc = 'Change surrounding' },
      { 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], mode = 'x' },
      { 'yss', 'ys_', remap = true },
    },
  },
  {
    'mg979/vim-visual-multi',
    config = function()
      vim.g.VM_silent_exit = true
      vim.g.VM_set_statusline = 0
      vim.g.VM_quit_after_leaving_insert_mode = true
      vim.g.VM_show_warnings = 0
    end,
    keys = { { '<C-n>', mode = { 'n', 'v' }, desc = 'Multi cursors' } },
  },
  {
    'altermo/ultimate-autopair.nvim',
    event = events.enter_insert,
    opts = {
      tabout = {
        enable = true,
        map = '<Tab>',
        cmap = '<Tab>',
        hopout = true,
      },
      space2 = { enable = true },
      fastwrap = { faster = true },
    },
  },
  {
    'tiagovla/scope.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'LunarVim/bigfile.nvim',
    event = events.enter_buffer,
  },
  {
    'chrisgrieser/nvim-spider',
    keys = {
      { 'w', "<Cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' }, desc = 'Next word' },
      { 'e', "<Cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' }, desc = 'Next end of word' },
      { 'b', "<Cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' }, desc = 'Previous word' },
      { 'ge', "<Cmd>lua require('spider').motion('ge')<CR>", mode = { 'n', 'o', 'x' }, desc = 'Previous end of word' },
    },
  },
  {
    'willothy/flatten.nvim',
    opts = { window = { open = 'alternate' } },
  },
  {
    'axkirillov/hbac.nvim',
    event = events.enter_buffer,
    opts = { threshold = 6 },
  },
  {
    'echasnovski/mini.operators',
    keys = {
      { 'g=', mode = { 'n', 'v' }, desc = 'Evaluate' },
      { 'cx', mode = { 'n', 'v' }, desc = 'Exchange' },
      { 'gm', mode = { 'n', 'v' }, desc = 'Dumplicate' },
      { 'gr', mode = { 'n', 'v' }, desc = 'Replace with register' },
      { 'gS', mode = { 'n', 'v' }, desc = 'Sort' },
    },
    opts = {
      sort = { prefix = 'gS' },
      exchange = { prefix = 'cx' },
    },
  },
  {
    'echasnovski/mini.bufremove',
    config = true,
    keys = { { '<C-q>', function() require('mini.bufremove').delete(0, false) end, desc = 'Close buffer' } },
  },
  {
    'RRethy/nvim-treesitter-endwise',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'InsertEnter',
    main = 'nvim-treesitter.configs',
    opts = { endwise = { enable = true } },
  },
  {
    'chrisgrieser/nvim-recorder',
    opts = { mapping = { switchSlot = '<M-q>' } },
    keys = {
      'q',
      'Q',
      '<M-q>',
      { 'cq', desc = 'Edit macro' },
      { 'dq', desc = 'Delete all macros' },
      { 'yq', desc = 'Yank macro' },
    },
  },
  {
    'fnune/recall.nvim',
    config = function()
      require('recall').setup()
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function() require('recall').clear() end,
      })
    end,
    dependencies = 'nvim-telescope/telescope.nvim',
    keys = {
      { '<Leader>sm', '<Cmd>Telescope recall<CR>', desc = 'Marks' },
      { '<Leader>fm', function() require('recall').toggle() end, desc = 'Toggle mark here' },
      { ']m', function() require('recall').goto_next() end, desc = 'Next mark' },
      { '[m', function() require('recall').goto_prev() end, desc = 'Previous mark' },
      { 'dm', function() require('recall').clear() end, desc = 'Delete all marks' },
    },
  },
  {
    'Wansmer/sibling-swap.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      keymaps = {
        ['<M-l>'] = 'swap_with_right',
        ['<M-h>'] = 'swap_with_left',
      },
    },
    keys = {
      { '<M-l>', desc = 'Swap with right' },
      { '<M-h>', desc = 'Swap with left' },
    },
  },
  {
    'tzachar/highlight-undo.nvim',
    keys = { 'u', '<C-r>' },
    opts = {
      undo = { hlgroup = 'IncSearch' },
      redo = { hlgroup = 'IncSearch' },
    },
  },
  {
    'lambdalisue/suda.vim',
    cmd = { 'SudaRead', 'SudaWrite' },
  },
  {
    'folke/persistence.nvim',
    event = events.enter_buffer,
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      { '<Leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
      { '<Leader>ql', function() require('persistence').load { last = true } end, desc = 'Restore Last Session' },
      {
        '<Leader>qd',
        function()
          require('persistence').stop()
          vim.cmd.qall()
        end,
        desc = "Don't Save Current Session",
      },
      {
        '<Leader>qc',
        function() os.remove(require('persistence').get_current()) end,
        desc = 'Delete current session',
      },
      {
        '<Leader>qC',
        function()
          for _, s in ipairs(require('persistence').list()) do
            os.remove(s)
          end
        end,
        desc = 'Delete all sessions',
      },
      {
        '<Leader>sq',
        function()
          local sessions = {}
          local persistence = require('persistence')
          for _, p in ipairs(persistence.list()) do
            local s = vim.fs.basename(p):gsub('%%', '/')
            sessions[#sessions + 1] = string.sub(s, 1, string.len(s) - 4)
          end
          vim.ui.select(sessions, { prompt = 'Session' }, function(choice)
            if choice == nil then
              return
            end
            vim.cmd.cd(choice)
            persistence.current = persistence.get_current()
            persistence.load()
          end)
        end,
        desc = 'Sessions',
      },
    },
  },
  {
    'keaising/im-select.nvim',
    event = events.enter_insert,
    opts = {},
  },
}
