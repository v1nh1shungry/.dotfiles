local events = require('utils.events')
local diagnostic_signs = require('utils.ui').icons.diagnostic
local excluded_filetypes = require('utils.ui').excluded_filetypes

return {
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    event = events.enter_buffer,
    keys = {
      { '[t',         function() require('todo-comments').jump_prev() end, desc = 'Previous TODO' },
      { ']t',         function() require('todo-comments').jump_next() end, desc = 'Next TODO' },
      { '<Leader>xt', '<Cmd>TodoTrouble<CR>',                              desc = 'Todo' },
      { '<Leader>xT', '<Cmd>TodoTrouble keywords=TODO,FIX,FIXME<CR>',      desc = 'Todo/Fix/Fixme' },
      { '<Leader>st', '<Cmd>TodoTelescope<CR>',                            desc = 'Todo' },
      { '<Leader>sT', '<Cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>',    desc = 'Todo/Fix/Fixme' },
    },
    opts = { signs = false },
  },
  {
    'goolord/alpha-nvim',
    config = function()
      local dashboard = require('alpha.themes.dashboard')
      local logo = [[
 __    __ __     __ ______ __       __      __    __ ________ _______   ______
|  \  |  \  \   |  \      \  \     /  \    |  \  |  \        \       \ /      \
| ▓▓\ | ▓▓ ▓▓   | ▓▓\▓▓▓▓▓▓ ▓▓\   /  ▓▓    | ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\
| ▓▓▓\| ▓▓ ▓▓   | ▓▓ | ▓▓ | ▓▓▓\ /  ▓▓▓    | ▓▓__| ▓▓ ▓▓__   | ▓▓__| ▓▓ ▓▓  | ▓▓
| ▓▓▓▓\ ▓▓\▓▓\ /  ▓▓ | ▓▓ | ▓▓▓▓\  ▓▓▓▓    | ▓▓    ▓▓ ▓▓  \  | ▓▓    ▓▓ ▓▓  | ▓▓
| ▓▓\▓▓ ▓▓ \▓▓\  ▓▓  | ▓▓ | ▓▓\▓▓ ▓▓ ▓▓    | ▓▓▓▓▓▓▓▓ ▓▓▓▓▓  | ▓▓▓▓▓▓▓\ ▓▓  | ▓▓
| ▓▓ \▓▓▓▓  \▓▓ ▓▓  _| ▓▓_| ▓▓ \▓▓▓| ▓▓    | ▓▓  | ▓▓ ▓▓_____| ▓▓  | ▓▓ ▓▓__/ ▓▓
| ▓▓  \▓▓▓   \▓▓▓  |   ▓▓ \ ▓▓  \▓ | ▓▓    | ▓▓  | ▓▓ ▓▓     \ ▓▓  | ▓▓\▓▓    ▓▓
 \▓▓   \▓▓    \▓    \▓▓▓▓▓▓\▓▓      \▓▓     \▓▓   \▓▓\▓▓▓▓▓▓▓▓\▓▓   \▓▓ \▓▓▓▓▓▓
]]
      dashboard.section.header.val = vim.split(logo, '\n')
      dashboard.section.buttons.val = {
        dashboard.button('f', ' ' .. ' Find file', '<Cmd>Telescope find_files<CR>'),
        dashboard.button('e', ' ' .. ' New file', '<Cmd>ene | startinsert<CR>'),
        dashboard.button('r', ' ' .. ' Recent files', '<Cmd>Telescope oldfiles cwd_only=true<CR>'),
        dashboard.button('/', ' ' .. ' Find text', '<Cmd>Telescope live_grep<CR>'),
        dashboard.button('c', ' ' .. ' Config', '<Cmd>e ~/.nvimrc<CR>'),
        dashboard.button('l', '󰒲 ' .. ' Lazy', '<Cmd>Lazy<CR>'),
        dashboard.button('q', ' ' .. ' Quit', '<Cmd>qa<CR>'),
      }
      dashboard.opts.layout[1].val = 8
      require('alpha').setup(dashboard.opts)

      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          once = true,
          pattern = 'AlphaReady',
          callback = function() require('lazy').show() end,
        })
      end
      vim.api.nvim_create_autocmd('User', {
        once = true,
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  {
    'gorbit99/codewindow.nvim',
    keys = {
      {
        '<Leader>um',
        function() require('codewindow').toggle_minimap() end,
        desc = 'Toggle Minimap',
      },
    },
    opts = { exclude_filetypes = excluded_filetypes, z_index = 50 },
  },
  {
    'lewis6991/satellite.nvim',
    event = events.enter_buffer,
    opts = { excluded_filetypes = excluded_filetypes },
  },
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { 'gb', '<Cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
      {
        ']b',
        function() for _ = 1, vim.v.count1 do vim.cmd 'BufferLineCycleNext' end end,
        desc = 'Next buffer',
      },
      {
        '[b',
        function() for _ = 1, vim.v.count1 do vim.cmd 'BufferLineCyclePrev' end end,
        desc = 'Previous buffer',
      },
    },
    opts = { options = { themable = true } },
  },
  {
    'stevearc/dressing.nvim',
    init = function()
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
    lazy = true,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      vim.opt.laststatus = 3
      require('lualine').setup {
        options = { component_separators = '', section_separators = '' },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {
            {
              'branch',
              icon = '',
              on_click = function() require('telescope.builtin').git_branches() end,
            },
            { 'mode', fmt = function(str) return '-- ' .. str .. ' --' end },
          },
          lualine_x = {
            { function() return '%S' end },
            {
              function()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                return string.format('Ln %s,Col %s', row, col + 1)
              end
            },
            {
              function() return 'Spaces: ' .. vim.bo.shiftwidth end,
              on_click = function()
                vim.ui.input({ prompt = 'Tab Size: ' }, function(input)
                  vim.bo.shiftwidth = tonumber(input)
                end)
              end,
            },
            { 'encoding',                fmt = function(str) return string.upper(str) end },
            {
              'fileformat',
              icons_enabled = true,
              symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' },
              on_click = function()
                local table = { LF = 'unix', CRLF = 'dos', CR = 'mac' }
                vim.ui.select(
                  { 'LF', 'CRLF', 'CR' },
                  { prompt = 'Line Ending:' },
                  function(choice)
                    if choice ~= nil then
                      vim.bo.fileformat = table[choice]
                    end
                  end
                )
              end,
            },
            { 'filetype', icons_enabled = false },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
        extensions = {
          'lazy',
          'man',
          'neo-tree',
          'nvim-dap-ui',
          'quickfix',
          'toggleterm',
          'trouble',
        },
      }
    end,
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = true,
    event = events.enter_buffer,
  },
  {
    'folke/which-key.nvim',
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
    event = 'VeryLazy',
    opts = {
      window = { winblend = require('user').ui.blend },
      layout = { height = { max = 10 } },
      defaults = {
        ['g'] = { name = '+goto' },
        [']'] = { name = '+next' },
        ['['] = { name = '+prev' },
        ['<Leader><Tab>'] = { name = '+tab' },
        ['<Leader>c'] = { name = '+code' },
        ['<Leader>f'] = { name = '+file' },
        ['<Leader>g'] = { name = '+Git' },
        ['<Leader>s'] = { name = '+search' },
        ['<Leader>u'] = { name = '+UI' },
        ['<Leader>x'] = { name = '+diagnostics/quickfix' },
      },
    },
  },
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        keys = {
          {
            '<Leader>un',
            function() require('notify').dismiss { silent = true, pending = true } end,
            desc = 'Dismiss all notifications',
          },
        },
        opts = { timeout = 3000 },
      },
    },
    event = 'VeryLazy',
    keys = {
      { '<Leader>xn', '<Cmd>Noice<CR>', desc = 'Message' },
      {
        '<C-f>',
        function() if not require('noice.lsp').scroll(4) then return '<C-f>' end end,
        silent = true,
        expr = true,
        desc = 'Scroll forward',
        mode = { 'i', 'n', 's' },
      },
      {
        '<C-b>',
        function() if not require('noice.lsp').scroll(-4) then return '<C-b>' end end,
        silent = true,
        expr = true,
        desc = 'Scroll backward',
        mode = { 'i', 'n', 's' },
      },
    },
    opts = {
      views = { split = { enter = true } },
      presets = { long_message_to_split = true, bottom_search = true, command_palette = true },
      messages = { view_search = false },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = { { find = '%d+L, %d+B' }, { find = '; after #%d+' }, { find = '; before #%d+' } },
          },
          view = 'mini',
        },
      },
    },
  },
  {
    'luukvbaal/statuscol.nvim',
    branch = '0.10',
    config = function()
      local builtin = require('statuscol.builtin')
      require('statuscol').setup {
        bt_ignore = { 'nofile', 'terminal' },
        ft_ignore = excluded_filetypes,
        relculright = true,
        segments = {
          { sign = { name = { 'RecallSign' } },    click = 'v:lua.ScSa' },
          { sign = { name = { 'Dap' } },           click = 'v:lua.ScSa' },
          { text = { builtin.lnumfunc },           click = 'v:lua.ScLa' },
          { sign = { namespace = { 'gitsigns' } }, click = 'v:lua.ScSa' },
          { text = { builtin.foldfunc },           click = 'v:lua.ScSa' },
        },
      }
    end,
    event = events.enter_buffer,
  },
  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup { calm_down = true }
      vim.api.nvim_create_autocmd('User', {
        callback = require('hlslens').start,
        pattern = 'visual_multi_start',
      })
      vim.api.nvim_create_autocmd('User', {
        callback = require('hlslens').stop,
        pattern = 'visual_multi_exit',
      })
    end,
    keys = {
      { '/',     desc = 'Forward search' },
      { '?',     desc = 'Backward search' },
      { '<C-n>', mode = { 'n', 'v' },     desc = 'Multi cursors' }, -- integrate with vim-visual-multi
      {
        'n',
        [[<Cmd>execute('normal! ' . v:count1 . 'Nn'[v:searchforward])<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = 'Next search result',
      },
      {
        'N',
        [[<Cmd>execute('normal! ' . v:count1 . 'nN'[v:searchforward])<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = 'Previous search result',
      },
      { '*', [[*<Cmd>lua require('hlslens').start()<CR>]], desc = 'Forward search current word' },
      { '#', [[#<Cmd>lua require('hlslens').start()<CR>]], desc = 'Backward search current word' },
    },
  },
  {
    'cbochs/portal.nvim',
    keys = {
      { '<C-o>', '<Cmd>Portal jumplist backward<CR>', desc = 'Jump backward' },
      { '<C-i>', '<Cmd>Portal jumplist forward<CR>',  desc = 'Jump forward' },
    },
  },
  {
    'Bekaboo/deadcolumn.nvim',
    event = events.enter_buffer,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    keys = { { '<Leader>e', '<Cmd>Neotree reveal toggle<CR>', desc = 'Explorer' } },
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      open_files_do_not_replace_types = excluded_filetypes,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ['h'] = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' and node:is_expanded() then
              require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
            else
              require 'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
            end
          end,
          ['l'] = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' then
              if not node:is_expanded() then
                require('neo-tree.sources.filesystem').toggle_directory(state, node)
              elseif node:has_children() then
                require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
              end
            elseif node.type == 'file' then
              require('neo-tree.sources.filesystem.commands').open(state)
            end
          end,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        diagnostics = {
          symbols = {
            hint = diagnostic_signs.hint,
            info = diagnostic_signs.info,
            warn = diagnostic_signs.warn,
            error = diagnostic_signs.error,
          },
        },
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function(_) vim.cmd 'Neotree close' end
        },
      },
    },
  },
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    dependencies = {
      'akinsho/bufferline.nvim',
      optional = true,
      opts = function()
        local Offset = require('bufferline.offset')
        if not Offset.edgy then
          local get = Offset.get
          Offset.get = function()
            if package.loaded.edgy then
              local layout = require('edgy.config').layout
              local ret = { left = '', left_size = 0, right = '', right_size = 0 }
              for _, pos in ipairs({ 'left', 'right' }) do
                local sb = layout[pos]
                if sb and #sb.wins > 0 then
                  local blank = (sb.bounds.width - 7) / 2
                  local title = string.rep(' ', blank) .. 'Sidebar' .. string.rep(' ', blank)
                  ret[pos] = '%#EdgyTitle#' .. title .. '%*' .. '%#WinSeparator#│%*'
                  ret[pos .. '_size'] = sb.bounds.width
                end
              end
              ret.total_size = ret.left_size + ret.right_size
              if ret.total_size > 0 then
                return ret
              end
            end
            return get()
          end
          Offset.edgy = true
        end
      end,
    },
    opts = {
      bottom = {
        {
          ft = 'toggleterm',
          size = { height = 0.4 },
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
        },
        {
          ft = 'noice',
          size = { height = 0.4 },
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
        },
        'Trouble',
        { ft = 'qf',                   title = 'QuickFix' },
        {
          ft = 'help',
          size = { height = 0.4 },
          filter = function(buf)
            return vim.bo[buf].buftype == 'help'
          end,
        },
        { ft = 'cmake_tools_terminal', title = 'CMakeTools Terminal' },
        { ft = 'dap-repl',             title = 'REPL' },
        { ft = 'dapui_console',        title = 'Console' },
      },
      left = {
        {
          title = 'Explorer',
          ft = 'neo-tree',
          filter = function(buf)
            return vim.b[buf].neo_tree_source == 'filesystem'
          end,
          open = function()
            vim.api.nvim_input('<esc><space>e')
          end,
          size = { height = 0.6 },
        },
        'neo-tree',
        {
          ft = 'dapui_scopes',
          title = 'Scopes',
          size = { height = 0.25 },
        },
        {
          ft = 'dapui_breakpoints',
          title = 'Breakpoints',
          size = { height = 0.25 },
        },
        {
          ft = 'dapui_stacks',
          title = 'Stacks',
          size = { height = 0.25 },
        },
        {
          ft = 'dapui_watches',
          title = 'Watches',
          size = { height = 0.25 },
        },
      },
      right = {
        { title = 'Outline', ft = 'sagaoutline' },
        {
          title = 'Clang AST',
          ft = 'ClangdAST',
          size = { width = 0.4 },
        },
        {
          title = 'Treesitter',
          ft = 'query',
          size = { width = 0.4 },
        },
        {
          title = 'Spectre',
          ft = 'spectre_panel',
          size = { width = 0.5 },
        },
      },
    },
  },
  {
    'echasnovski/mini.trailspace',
    config = function()
      require('mini.trailspace').setup()
      vim.cmd 'highlight MiniTrailspace ctermbg=LightGreen guibg=LightGreen'
    end,
    event = events.enter_buffer,
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args) vim.b[args.buf].minitrailspace_disable = true end,
        pattern = excluded_filetypes,
      })
    end,
  },
  {
    'b0o/incline.nvim',
    event = events.enter_buffer,
    opts = {
      render = function(props)
        local label = {}
        if #vim.lsp.get_clients({ bufnr = props.buf }) > 0 then
          local icons = {
            Error = diagnostic_signs.error,
            Warn = diagnostic_signs.warn,
            Hint = diagnostic_signs.hint,
            Info = diagnostic_signs.info,
          }
          for severity, icon in pairs(icons) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              table.insert(label, { icon .. ' ' .. n .. ' ', group = 'DiagnosticSign' .. severity })
            end
          end
          if #label == 0 then
            table.insert(label, { '✔', guifg = 'green' })
          end
        end
        return label
      end,
      ignore = { filetypes = excluded_filetypes },
    },
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'MeanderingProgrammer/markdown.nvim',
    main = 'render-markdown',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    ft = 'markdown',
    opts = { conceal = { rendered = 0 } },
  },
  {
    'mcauley-penney/visual-whitespace.nvim',
    event = events.enter_buffer,
    opts = {},
  },
  {
    'hiphish/rainbow-delimiters.nvim',
    main = 'rainbow-delimiters.setup',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = events.enter_buffer,
    opts = { highlight = require('utils.ui').rainbow_highlight },
  },
  {
    'kevinhwang91/nvim-ufo',
    config = function(_, opts)
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require('ufo').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        command = 'UfoDetach',
        pattern = excluded_filetypes,
      })
    end,
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    opts = {
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
          winhighlight = 'Normal:UfoPreviewNormal,FloatBorder:UfoPreviewBorder,CursorLine:UfoPreviewCursorLine',
          winblend = require('user').ui.blend,
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
          jumpTop = '[',
          jumpBot = ']',
        },
      },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    },
    keys = { { '<Leader>uf', function() require('ufo').peekFoldedLinesUnderCursor() end, desc = 'Preview fold' } },
  },
}
