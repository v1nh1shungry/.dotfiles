return function()
  vim.g.quickui_border_style = 2
  vim.fn['quickui#menu#reset']()
  vim.fn['quickui#menu#install']('&File', {
    { '&Open\t<C-p>', 'Telescope file_browser' },
    { '--', '' },
    { '&Save\t<C-s>', 'write' },
    { 'Save &All', 'wall' },
    { '--', '' },
    { 'Sudo Open', 'SudaRead' },
    { 'Sudo Save', 'SudaWrite' },
    { '--', '' },
    { '&Exit\tQ', 'qa!' },
  })
  vim.fn['quickui#menu#install']('&Edit', {
    { '&Comment Box', 'CBcbox' },
    { '&Venn Box', 'VBox' },
    { '--', '' },
    { '&Table Mode\t<Leader>tm', 'TableModeToggle' },
    { '--', '' },
    { '&Strip Trailing', 'StripWhitespace' },
    { '&Format Codes\t=', 'lua vim.lsp.buf.format { async = true }' },
  })
  vim.fn['quickui#menu#install']('&View', {
    { '&Terminal\t<M-=>', 'ToggleTerm' },
    { 'File &Explorer\t<Leader>e', 'NeoTreeShowToggle' },
    { '&Outline\t<Leader>o', 'LSoutlineToggle' },
    { '&Minimap\t<Leader>mm', 'lua require("codewindow").toggle_minimap()' },
  })
  vim.fn['quickui#menu#install']('&Navigation', {
    { '&Find', 'Farf' },
    { 'Find And Re&place', 'Farr' },
    { 'Live &Grep', 'Telescope live_grep' },
    { '--', '' },
    { 'Goto &Definitions\tgd', 'TroubleToggle lsp_definitions' },
    { 'Goto &Implementation', 'TroubleToggle lsp_implementations' },
    { 'Goto T&ype Definitions\tgy', 'TroubleToggle lsp_type_definitions' },
    { 'Goto &References\tgR', 'TroubleToggle lsp_references' },
    { '--', '' },
    { 'Document &Symbols', 'Telescope lsp_document_symbols' },
    { 'Works&pace Symbols', 'Telescope lsp_workspace_symbols' },
    { 'Document Di&agnostics', 'TroubleToggle document_diagnostics' },
    { '&Workspace Diagnostics', 'TroubleToggle workspace_diagnostics' },
    { '--', '' },
    { '&TODO', 'TodoTrouble' },
  })
  vim.fn['quickui#menu#install']('&Git', {
    { 'Git &Diff', 'Gvdiffsplit' },
    { 'Git Bl&ame', 'Gitsigns toggle_current_line_blame' },
  })
  vim.fn['quickui#menu#install']('&Build', {
    { '&Build\t<Leader>fb', 'AsyncTask file-build' },
    { '&Run\t<Leader>fr', 'AsyncTask file-run' },
    { '--', '' },
    { '&Remote Compile', 'CECompile' },
    { '&Live Compile', 'CECompileLive' },
  })
  vim.fn['quickui#menu#install']('&Debug', {
    { '&Continue\t<F5>', 'DapContinue' },
    { '&Terminate', 'DapTerminate' },
    { '--', '' },
    { '&Breakpoint\t<F9>', 'DapToggleBreakpoint' },
    { 'Con&ditional Breakpoint', "lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))" },
    { 'Lo&g Breakpoint', "lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))" },
    { '--', '' },
    { '&Step Over\t<F10>', 'DapStepOver' },
    { 'Step &Into\t<F11>', 'DapStepInto' },
    { 'Step &Out\t<F12>', 'DapStepOut' },
  })
  vim.fn['quickui#menu#install']('&Plugins', {
    { '&Install', 'PackerInstall' },
    { '&Update', 'PackerSync' },
    { '&Clean Unused', 'PackerClean' },
    { '&Refresh Settings', 'PackerCompile' },
    { '--', '' },
    { '&Status', 'PackerStatus' },
    { 'Co&mmands', 'Telescope commands' },
  })
  vim.fn['quickui#menu#install']('&Tools', {
    { '&Package Manager', 'Mason' },
    { '&Startup Time', 'StartupTime' },
    { '&REPL', 'Codi!!' },
    { '&Markdown Preview', 'MarkdownPreview' },
  })
  vim.fn['quickui#menu#install']('Help (&?)', {
    { 'Help (&?)\t<Leader>h', 'Telescope help_tags' },
    { 'M&an Pages', 'Telescope man_pages' },
    { '&Welcome', 'Alpha' },
    { '--', '' },
    { '&Options', 'Telescope vim_options' },
    { 'Auto&cmds', 'Telescope autocommands' },
    { 'Ke&ymaps', 'Telescope keymaps' },
    { '--', '' },
    { '&Messages', 'Noice' },
  })
  vim.g.context_menu_k = {
    { '&Hover\tgh', 'Lspsaga hover_doc' },
    { 'Di&agnostics', 'Lspsaga show_cursor_diagnostics' },
    { '&Preview Definition', 'Lspsaga peek_definition' },
    { '--', '' },
    { '&Rename\t<Leader>rn', 'Lspsaga rename' },
    { '&Code Action\t<Leader>ca', 'Lspsaga code_action' },
    { 'Do&ge Here', 'DogeGenerate' },
    { '--', '' },
    { '&Grep', 'Telescope grep_string' },
    { '--', '' },
    { 'Cpp&man', 'exec "Cppman " . expand("<cword>")' },
  }

  require('utils.keymaps').nnoremap('<Space><Space>', '<Cmd>call quickui#menu#open()<CR>')
  require('utils.keymaps').xnoremap('<Space><Space>', ':<C-u>call quickui#menu#open()<CR>')
  require('utils.keymaps').nnoremap('K',
    '<Cmd>if &ft == "help" | call feedkeys("K", "in") | else | call quickui#context#open(g:context_menu_k, {}) | endif<CR>')
  require('utils.keymaps').xnoremap('K',
    ':<C-u>if &ft == "help" | call feedkeys("K", "in") | else | call quickui#context#open(g:context_menu_k, {}) | endif<CR>')
  require('utils.keymaps').nnoremap('<RightMouse>', function()
    vim.fn['quickui#context#open'](vim.g.context_menu_k, vim.empty_dict())
  end)
  require('utils.keymaps').xnoremap('<RightMouse>', ':<C-u>call quickui#context#open(g:context_menu_k, {})<CR>')
end
