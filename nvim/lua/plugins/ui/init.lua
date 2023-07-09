local events = require('utils.events')

return {
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    event = events.enter_buffer,
    keys = {
      { '[t',         function() require('todo-comments').jump_prev() end, desc = 'Previous TODO' },
      { ']t',         function() require('todo-comments').jump_next() end, desc = 'Next TODO' },
      { '<Leader>xt', '<Cmd>TodoTrouble<CR>',                              desc = 'Todo' },
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
        dashboard.button('r', ' ' .. ' Recent files', '<Cmd>Telescope oldfiles cwd_only=true<CR>'),
        dashboard.button('f', ' ' .. ' Find file', '<Cmd>Telescope find_files<CR>'),
        dashboard.button('p', ' ' .. ' Find text', '<Cmd>Telescope live_grep<CR>'),
        dashboard.button('c', ' ' .. ' Config', '<Cmd>e ~/.nvimrc<CR>'),
        dashboard.button('l', '鈴' .. ' Lazy', '<Cmd>Lazy<CR>'),
        dashboard.button('q', ' ' .. ' Quit', '<Cmd>qa<CR>'),
      }
      dashboard.opts.layout[1].val = 2
      require('alpha').setup(dashboard.opts)

      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'AlphaReady',
          callback = function() require('lazy').show() end,
        })
      end
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {
    'gorbit99/codewindow.nvim',
    keys = { { '<Leader>um', function() require('codewindow').toggle_minimap() end, desc = 'Toggle Minimap' } },
    opts = {
      exclude_filetypes = require('utils.ui').excluded_filetypes,
      z_index = 50,
    },
  },
  {
    'lewis6991/satellite.nvim',
    event = events.enter_buffer,
    opts = { excluded_filetypes = require('utils.ui').excluded_filetypes },
  },
  {
    'akinsho/bufferline.nvim',
    event = events.enter_buffer,
    keys = { { 'gb', '<Cmd>BufferLinePick<CR>', desc = 'Pick buffer' } },
    opts = {
      options = {
        offsets = {
          {
            filetype = 'lspsagaoutline',
            text = 'Outline',
            text_align = 'center',
            separator = true,
          },
          {
            filetype = 'ClangdAST',
            text = 'Clangd AST',
            text_align = 'center',
            separator = true,
          },
          {
            filetype = 'query',
            text = 'Treesitter Inspect',
            text_align = 'center',
            separator = true,
          },
        },
        separator_style = 'slant',
      },
    },
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
      local theme = require('user').ui.statusline_theme
      local opts = require('plugins.ui.lualine.' .. theme)
      opts.extensions = { 'lazy', 'man', 'nvim-dap-ui', 'quickfix', 'toggleterm', 'trouble' }
      require('lualine').setup(opts)
    end,
    event = events.enter_buffer,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = true,
    event = events.enter_buffer,
  },
  {
    'folke/which-key.nvim',
    config = function()
      local wk = require('which-key')
      wk.setup {
        window = { winblend = require('user').ui.blend },
        layout = { height = { max = 10 } },
      }
      wk.register({
        ['<Leader><Tab>'] = { name = '+tab' },
        ['<Leader>c'] = { name = '+code' },
        ['<Leader>d'] = { name = '+debug' },
        ['<Leader>f'] = { name = '+file' },
        ['<Leader>g'] = { name = '+Git' },
        ['<Leader>s'] = { name = '+search' },
        ['<Leader>u'] = { name = '+UI' },
        ['<Leader>x'] = { name = '+diagnostics/quickfix' },
      })
    end,
    event = 'VeryLazy',
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
        opts = { top_down = false, timeout = 3000 },
      },
    },
    event = 'VeryLazy',
    keys = { { '<Leader>xn', '<Cmd>Noice<CR>', desc = 'Message' } },
    opts = {
      views = { split = { enter = true } },
      presets = { long_message_to_split = true, bottom_search = true, command_palette = true },
      messages = { view_search = false },
      lsp = {
        signature = { enabled = false },
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
    config = function()
      local builtin = require('statuscol.builtin')
      require('statuscol').setup {
        bt_ignore = { 'terminal' },
        ft_ignore = require('utils.ui').excluded_filetypes,
        relculright = true,
        segments = {
          { sign = { name = { '.*' } },       click = 'v:lua.ScSa' },
          { text = { builtin.lnumfunc },      click = 'v:lua.ScLa', },
          { sign = { name = { 'GitSigns' } }, click = 'v:lua.ScSa' },
        },
      }
    end,
    event = events.enter_buffer,
  },
  {
    'HiPhish/nvim-ts-rainbow2',
    dependencies = 'nvim-treesitter/nvim-treesitter',
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
    'cbochs/portal.nvim',
    keys = {
      { '<C-o>', '<Cmd>Portal jumplist backward<CR>' },
      { '<C-i>', '<Cmd>Portal jumplist forward<CR>' },
    },
  },
}
