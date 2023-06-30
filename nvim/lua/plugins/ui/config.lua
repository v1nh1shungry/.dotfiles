local M = {}

local excluded_filetypes = require('utils.ui').excluded_filetypes

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
    { '&Open\t<C-p>',              'Telescope find_files' },
    { 'Recent &Files\t<Leader>rf', 'Telescope oldfiles' },
    { '--',                        '' },
    { '&Save\t<C-s>',              'write' },
    { 'Save &All',                 'wall' },
    { '--',                        '' },
    { '&Preference',               'e ~/.nvimrc' },
    { '--',                        '' },
    { 'TO&DO',                     'TodoTrouble' },
  })
  vim.fn['quickui#menu#install']('&View', {
    { '&Terminal\t<M-=>',          'ToggleTerm' },
    { 'File &Explorer\t<Leader>e', 'lua MiniFiles.open()' },
    { '&Outline\t<Leader>o',       'Lspsaga outline' },
    { '&Minimap\t<Leader>mm',      'lua require("codewindow").toggle_minimap()' },
    { 'Tree&sitter',               'lua vim.treesitter.inspect_tree({ command = "bo 60vnew" })' },
    { '&Undotree\t<Leader>u',      'UndotreeToggle' },
    { '--',                        '' },
    { 'Markdown Pre&view',         'MarkdownPreview' },
  })
  vim.fn['quickui#menu#install']('&Intellisense', {
    { '&Symbols\t<Leader>ss',        'Telescope lsp_document_symbols' },
    { 'Di&agnostics',                'Trouble document_diagnostics' },
    { '&Lspsaga Finder\t<Leader>lf', 'Lspsaga lsp_finder' },
    { '--',                          '' },
    { 'Goto &Definitions\tgd',       'Glance definitions' },
    { 'Goto T&ype Definitions\tgy',  'Glance type_definitions' },
    { 'Goto &References\tgR',        'Glance references' },
    { '&Incoming Calls',             'Lspsaga incoming_calls' },
    { '&Outgoing Calls',             'Lspsaga outgoing_calls' },
    { '--',                          '' },
    { '&Mason',                      'Mason' },
  })
  vim.fn['quickui#menu#install']('&Git', {
    { 'Git Bl&ame',                    'Gitsigns toggle_current_line_blame' },
    { 'Git &Diff\t<Leader>gd',         'Gvdiffsplit' },
    { 'Git &Preview Hunk\t<Leader>gp', 'Gitsigns preview_hunk' },
    { 'Git Re&set Hunk\t<Leader>gr',   'Gitsigns reset_hunk' },
    { '&Fugitive\t<Leader>gg',         'tab Git' },
  })
  vim.fn['quickui#menu#install']('&Build', {
    { '&Build\t<Leader>fb', 'AsyncTask file-build' },
    { '&Run\t<Leader>fr',   'AsyncTask file-run' },
    { '--',                 '' },
    { '&Remote Compile',    'CECompile' },
    { 'L&ive Compile',      'CECompileLive' },
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
end

M.lualine = function()
  vim.opt.laststatus = 3
  local theme = require('user').ui.statusline_theme
  local opts = require('plugins.ui.lualine.' .. theme)
  opts.extensions = { 'man', 'nvim-dap-ui', 'quickfix', 'toggleterm' }
  require('lualine').setup(opts)
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
          text = 'Treesitter Inspect Tree',
          text_align = 'center',
          separator = true,
        },
      },
      separator_style = 'slant',
    },
  }
  require('utils.keymaps').nnoremap('gb', '<Cmd>BufferLinePick<CR>')
end

M.statuscol = function()
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
end

M.hlslens = function()
  require('hlslens').setup { calm_down = true, nearest_only = true }
  vim.api.nvim_create_autocmd('User', {
    callback = require('hlslens').start,
    pattern = 'visual_multi_start',
  })
  vim.api.nvim_create_autocmd('User', {
    callback = require('hlslens').stop,
    pattern = 'visual_multi_exit',
  })
end

return M
