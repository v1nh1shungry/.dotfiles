local M = {}

M.icons = {
  diagnostics = {
    error = '',
    warning = '',
    hint = '',
    info = '',
  },
  dap = {
    breakpoint = '󰝥',
    breakpoint_condition = 'ﳁ',
    breakpoint_rejected = '',
    log_point = '',
  },
}

M.excluded_filetypes = {
  'ClangdAST',
  'Trouble',
  'alpha',
  'dap-repl',
  'dapui_breakpoints',
  'dapui_console',
  'dapui_scopes',
  'dapui_stacks',
  'dapui_watches',
  'help',
  'lazy',
  'lspinfo',
  'mason',
  'minifiles',
  'minifiles-help',
  'noice',
  'qf',
  'query',
  'sagafinder',
  'sagaoutline',
  'ssr',
}

return M
