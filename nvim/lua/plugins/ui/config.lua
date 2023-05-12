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
    { '&Open\t<C-p>',   'Telescope find_files' },
    { 'Open Settin&gs', 'e ~/.nvimrc' },
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
    { '--',                            '' },
    { 'Edit &Markdown Code Block',     'FeMaco' },
    { '--',                            '' },
    { '&Format Codes\t=',              'lua vim.lsp.buf.format { async = true }' },
  })
  vim.fn['quickui#menu#install']('&View', {
    { '&Terminal\t<M-=>',          'ToggleTerm' },
    { 'File &Explorer\t<Leader>e', 'NeoTreeFocusToggle' },
    { '&Outline\t<Leader>o',       'Lspsaga outline' },
    { '&Minimap\t<Leader>mm',      'lua require("codewindow").toggle_minimap()' },
    { 'Treesitter &Inspect',       'lua vim.treesitter.inspect_tree({ command = "bo 60vnew" })' },
    { '--',                        '' },
    { 'Markdown Pre&view',         'MarkdownPreview' },
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
    { 'Git Bl&ame',        'Gitsigns toggle_current_line_blame' },
    { 'Git &Diff',         'Gvdiffsplit' },
    { 'Git &Preview Hunk', 'Gitsigns preview_hunk' },
    { '--',                '' },
    { 'Git Re&set Hunk',   'Gitsigns reset_hunk' },
    { 'Git &Remove',       'GDelete' },
    { 'Git Re&name',       'lua vim.ui.input({ prompt = "Rename to:" }, function(input) vim.cmd.GRename(input) end)' },
    { '--',                '' },
    { '&Magit',            'Neogit' },
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
  vim.fn['quickui#menu#install']('&Plugins', {
    { '&Update',       'Lazy sync' },
    { '&Clean Unused', 'Lazy clean' },
    { '--',            '' },
    { 'H&ome',         'Lazy home' },
    { '&Profile',      'Lazy profile' },
    { '--',            '' },
    { '&Mason',        'Mason' },
  })
  vim.fn['quickui#menu#install']('Help (&?)', {
    { 'Help (&?)\t<Leader>h', 'Telescope help_tags' },
    { '&Notifications',       'Noice' },
  })
  require('utils.keymaps').nnoremap('<M-Space>', function()
    vim.fn['quickui#context#open']({
      { 'Di&agnostics',            'Lspsaga show_line_diagnostics' },
      { '&Preview Definition',     'Lspsaga peek_definition' },
      { '--',                      '' },
      { '&Lspsaga Finder',         'Lspsaga lsp_finder' },
      { '&Incoming Calls',         'Lspsaga incoming_calls' },
      { '&Outgoing Calls',         'Lspsaga outgoing_calls' },
      { '--',                      '' },
      { '&Rename\t<Leader>rn',     'Lspsaga rename' },
      { '&Code Action\t<M-Enter>', 'Lspsaga code_action' },
      { '&Generate Document',      'Neogen' },
      { '--',                      '' },
      { 'Cpp&man',                 'exec "Cppman " . expand("<cword>")' },
    }, vim.empty_dict())
  end)
end

M.lualine = function()
  vim.opt.laststatus = 3
  local theme = require('user').ui.statusline_theme
  local opts = require('plugins.ui.lualine.' .. theme)
  opts.extensions = { 'man', 'neo-tree', 'nvim-dap-ui', 'quickfix', 'toggleterm' }
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

M.ufo = function()
  vim.opt.foldcolumn = '1'
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true

  local builtin = require('statuscol.builtin')
  require('statuscol').setup {
    bt_ignore = { 'terminal' },
    ft_ignore = require('utils.ui').excluded_filetypes,
    relculright = true,
    segments = {
      { sign = { name = { '.*' } },       click = 'v:lua.ScSa' },
      { text = { builtin.lnumfunc },      click = 'v:lua.ScLa', },
      { sign = { name = { 'GitSigns' } }, click = 'v:lua.ScSa' },
      { text = { builtin.foldfunc },      click = 'v:lua.ScFa' },
    },
  }

  require('ufo').setup {
    provider_selector = function(_, _, _) return { 'treesitter', 'indent' } end,
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = ('  %d '):format(endLnum - lnum)
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
  }
end

return M
