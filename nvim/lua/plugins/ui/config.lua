local M = {}

local excluded_filetypes = {
  'ClangdAST',
  'Trouble',
  'alpha',
  'dap-repl',
  'dapui_breakpoints',
  'dapui_console',
  'dapui_scopes',
  'dapui_stacks',
  'dapui_watches',
  'lazy',
  'lspsagaoutline',
  'mason',
  'neo-tree',
  'qf',
}

M.alpha = function()
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
    dashboard.button('l', '鈴' .. ' Lazy', '<Cmd>Lazy<CR>'),
    dashboard.button('q', ' ' .. ' Quit', '<Cmd>qa<CR>'),
  }
  dashboard.opts.layout[1].val = 4
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
end

M.codewindow = function()
  local codewindow = require('codewindow')
  codewindow.setup {
    exclude_filetypes = excluded_filetypes,
    z_index = 50,
  }
  codewindow.apply_default_keybinds()
end

M.quickui = function()
  vim.fn['quickui#menu#reset']()
  vim.fn['quickui#menu#install']('&File', {
    { '&Open\t<C-p>',   'Telescope find_files' },
    { 'Open Settin&gs', 'e ~/.nvimrc.lua' },
    { '--',             '' },
    { '&Save\t<C-s>',   'write' },
    { 'Save &All',      'wall' },
    { '--',             '' },
    { '&Delete',        'Delete' },
    { '&Rename',        'lua vim.ui.input({ prompt = "Rename to: " }, function(input) vim.cmd.Rename(input) end)' },
    { '--',             '' },
    { '&Exit\tQ',       'qa!' },
  })
  vim.fn['quickui#menu#install']('&Edit', {
    { '&Find And Replace\t<Leader>rw', 'SearchReplaceSingleBufferCWord' },
    { '&SSR\t<Leader>sr',              'lua require("ssr").open()' },
    { '&Table Mode\t<Leader>tm',       'TableModeToggle' },
    { '&Format Codes\t=',              'lua vim.lsp.buf.format { async = true }' },
    { 'Edit &Markdown Code Block',     'FeMaco' },
  })
  vim.fn['quickui#menu#install']('&View', {
    { '&Resize Windows\t<C-e>',    'WinResizerStartResize' },
    { '--',                        '' },
    { '&Terminal\t<M-=>',          'ToggleTerm' },
    { 'File &Explorer\t<Leader>e', 'NeoTreeFocusToggle' },
    { '&Outline\t<Leader>o',       'Lspsaga outline' },
    { '&Minimap\t<Leader>mm',      'lua require("codewindow").toggle_minimap()' },
    { '&Undo Tree',                'UndotreeToggle' },
    { '--',                        '' },
    { 'Di&agnostics',              'Lspsaga show_line_diagnostics' },
    { '&Preview Definition',       'Lspsaga peek_definition' },
  })
  vim.fn['quickui#menu#install']('&Navigation', {
    { 'Live &Grep',                 'Telescope live_grep' },
    { '--',                         '' },
    { 'Goto &Definitions\tgd',      'Glance definitions' },
    { 'Goto T&ype Definitions\tgy', 'Glance type_definitions' },
    { 'Goto &References\tgR',       'Glance references' },
    { '--',                         '' },
    { '&Symbols',                   'Telescope lsp_document_symbols' },
    { 'Di&agnostics',               'Trouble document_diagnostics' },
    { '--',                         '' },
    { '&TODO',                      'TodoTrouble' },
  })
  vim.fn['quickui#menu#install']('&Git', {
    { 'Git Bl&ame',  'Gitsigns toggle_current_line_blame' },
    { 'Git &Diff',   'Gvdiffsplit' },
    { '--',          '' },
    { 'Git &Remove', 'GDelete' },
    { 'Git Re&name', 'GRename' },
    { '--',          '' },
    { '&Magit',      'Neogit' },
  })
  vim.fn['quickui#menu#install']('&Build', {
    { '&Build\t<Leader>fb', 'AsyncTask file-build' },
    { '&Run\t<Leader>fr',   'AsyncTask file-run' },
    { '--',                 '' },
    { '&Remote Compile',    'CECompile' },
    { '&Live Compile',      'CECompileLive' },
  })
  vim.fn['quickui#menu#install']('&Debug', {
    { '&Continue\t<F5>',         'DapContinue' },
    { '&Terminate',              'DapTerminate' },
    { '--',                      '' },
    { '&Breakpoint\t<F9>',       'DapToggleBreakpoint' },
    { 'Con&ditional Breakpoint', "lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))" },
    { 'Lo&g Breakpoint',         "lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))" },
    { '--',                      '' },
    { '&Step Over\t<F10>',       'DapStepOver' },
    { 'Step &Into\t<F11>',       'DapStepInto' },
    { 'Step &Out\t<F12>',        'DapStepOut' },
  })
  vim.fn['quickui#menu#install']('&Plugins', {
    { '&Install',      'Lazy install' },
    { '&Update',       'Lazy sync' },
    { '&Clean Unused', 'Lazy clean' },
    { '--',            '' },
    { 'H&ome',         'Lazy home' },
    { '&Mason',        'Mason' },
    { '&Profile',      'Lazy profile' },
  })
  vim.fn['quickui#menu#install']('&Tools', {
    { '&Generate Document',  'Neogen' },
    { '&Emoji Picker',       'Telescope symbols' },
    { '&Treesitter Inspect', 'lua vim.treesitter.inspect_tree({ command = "bo 60vnew" })' },
  })
  vim.fn['quickui#menu#install']('Help (&?)', {
    { 'Help (&?)\t<Leader>h', 'Telescope help_tags' },
    { '&Welcome',             'Alpha' },
    { '--',                   '' },
    { '&Autocmds',            'Telescope autocommands' },
    { 'Ke&ymaps',             'Telescope keymaps' },
  })
end

M.lualine = function()
  vim.opt.laststatus = 3
  vim.opt.cmdheight = 1
  vim.opt.showcmd = true

  local theme = require('user').statusline_theme
  local opts = require('plugins.ui.lualine.' .. theme)
  opts.extensions = { 'man', 'neo-tree', 'nvim-dap-ui', 'quickfix', 'toggleterm' }
  require('lualine').setup(opts)
end

M.satellite = {
  excluded_filetypes = excluded_filetypes,
}

M.notify = function()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(...)
    local notify = require('notify')
    notify.setup {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    }
    vim.notify = notify
    return vim.notify(...)
  end
end

M.dressing = function()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(...)
    require('lazy').load({ plugins = { 'dressing.nvim' } })
    return vim.ui.select(...)
  end
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.input = function(...)
    require('lazy').load({ plugins = { 'dressing.nvim' } })
    return vim.ui.input(...)
  end
end

M.bufferline = function()
  require('bufferline').setup {
    options = {
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          text_align = 'center',
          separator = true,
        },
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
      },
      separator_style = 'slant',
    },
  }
  require('utils.keymaps').nnoremap('gb', '<Cmd>BufferLinePick<CR>')
end

return M
