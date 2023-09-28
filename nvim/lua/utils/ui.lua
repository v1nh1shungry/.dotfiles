local M = {}

M.icons = {
  diagnostic = {
    error = '',
    warn = '',
    hint = '',
    info = '',
  },
}

M.excluded_filetypes = {
  '',
  'ClangdAST',
  'NeogitPopup',
  'NeogitStatus',
  'Trouble',
  'checkhealth',
  'cmake_tools_terminal',
  'dap-repl',
  'dapui_breakpoints',
  'dapui_console',
  'dapui_scopes',
  'dapui_stacks',
  'dapui_watches',
  'diff',
  'edgy',
  'help',
  'lazy',
  'lspinfo',
  'man',
  'mason',
  'neo-tree',
  'noice',
  'qf',
  'query',
  'sagafinder',
  'sagaoutline',
  'spectre_panel',
  'ssr',
  'undotree',
}

return M
