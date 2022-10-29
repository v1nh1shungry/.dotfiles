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
    { 'Registers', 'Telescope registers' },
    { '--', '' },
    { '&Table Mode', 'TableModeToggle' },
    { '--', '' },
    { '&Strip Trailing', 'StripWhitespace' },
    { '&Format Codes\t<Leader>f', 'lua vim.lsp.buf.format { async = true }' },
  })
  vim.fn['quickui#menu#install']('&View', {
    { '&Resize Windows', 'WinResizerStartResize' },
    { '--', '' },
    { '&Terminal\t<M-=>', 'ToggleTerm' },
    { 'File &Explorer\t<Leader>e', 'NeoTreeShowToggle' },
    { '&Undotree\t<Leader>u', 'UndotreeToggle' },
    { '&Outline\t<Leader>o', 'LSoutlineToggle' },
  })
  vim.fn['quickui#menu#install']('&Navigation', {
    { '&Find', 'Farf' },
    { 'Find And Re&place', 'Farr' },
    { '--', '' },
    { 'Goto &Definitions\tgd', 'TroubleToggle lsp_definitions' },
    { 'Goto &Implementation', 'TroubleToggle lsp_implementations' },
    { 'Goto T&ype Definitions', 'TroubleToggle lsp_type_definitions' },
    { 'Goto &References\tgr', 'TroubleToggle lsp_references' },
    { '--', '' },
    { 'Document Di&agnostics', 'TroubleToggle document_diagnostics' },
    { '&Workspace Diagnostics', 'TroubleToggle workspace_diagnostics' },
    { '--', '' },
    { '&TODO', 'TodoTrouble' },
  })
  vim.fn['quickui#menu#install']('&Git', {
    { 'Git &Status', 'Git status' },
    { 'Git &Diff', 'Gvdiffsplit' },
    { 'Git &Browse', "call feedkeys(':Gvsplit ', 'in')" },
    { 'Git B&lame', 'Gitsigns blame_line' },
    { '--', '' },
    { 'Git &Reset Hunk', 'Gitsigns reset_hunk' },
  })
  vim.fn['quickui#menu#install']('&Build', {
    { '&Build\t<Leader>fb', 'AsyncTask file-build' },
    { '&Run\t<Leader>fr', 'AsyncTask file-run' },
    { '--', '' },
    { '&Remote Compile', 'CECompile' },
    { '&Live Compile', 'CECompileLive' },
  })
  vim.fn['quickui#menu#install']('&Plugins', {
    { '&Install', 'PackerInstall' },
    { '&Update', 'PackerSync' },
    { '&Clean Unused', 'PackerClean' },
    { '&Refresh', 'PackerCompile' },
    { '--', '' },
    { '&Status', 'PackerStatus' },
    { 'Co&mmands', 'Telescope commands' },
  })
  vim.fn['quickui#menu#install']('&Tools', {
    { '&Package Manager', 'Mason' },
    { '--', '' },
    { '&Startup Time', 'StartupTime' },
    { '&REPL', 'Codi!!' },
  })
  vim.fn['quickui#menu#install']('Help (&?)', {
    { 'Help\t<Leader>h', 'Telescope help_tags' },
    { '&Welcome', 'Alpha' },
    { '--', '' },
    { 'Ke&ymaps', 'Telescope keymaps' },
    { '--', '' },
    { '&Messages', 'call quickui#tools#display_messages()' },
    { '&Notifications', 'Telescope notify' },
  })
  local context_menu_k = {
    { '&Hover\tgh', 'Lspsaga hover_doc' },
    { 'Di&agnostics', 'Lspsaga show_line_diagnostics' },
    { '&Preview Definition', 'Lspsaga peek_definition' },
    { '--', '' },
    { '&Rename\t<Leader>rn', 'Lspsaga rename' },
    { '&Code Action\t<Leader>ca', 'Lspsaga code_action' },
    { '--', '' },
    { 'Do&ge Here', 'DogeGenerate' },
  }
  local function clever_k()
    if vim.bo.filetype == 'help' then
      vim.fn.feedkeys('K', 'in')
    else
      vim.fn['quickui#context#open'](context_menu_k, vim.empty_dict())
    end
  end

  require('utils.keymaps').nnoremap('<Space><Space>', '<Cmd>call quickui#menu#open()<CR>')
  require('utils.keymaps').nnoremap('K', clever_k)
end
