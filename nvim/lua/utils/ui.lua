local M = {}

M.icons = {
  diagnostics = {
    error = '',
    warning = '',
    hint = '',
    info = '',
  },
  dap = {
    breakpoint = '',
    breakpoint_condition = 'ﳁ',
    breakpoint_rejected = '',
    log_point = '',
  },
}

M.excluded_filetypes = {
  'ClangdAST',
  'NeogitStatus',
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
  'lspsagafinder',
  'lspsagaoutline',
  'mason',
  'minifiles',
  'minifiles-help',
  'noice',
  'qf',
  'query',
}

return M
