local M = {}

M.icons = {
  diagnostic = {
    error = '',
    warn = '',
    hint = '',
    info = '',
  },
  dap = {
    breakpoint = '󰝥',
    breakpoint_condition = '',
    breakpoint_rejected = '',
    log_point = '',
    stopped = '󰁕',
  },
}

M.excluded_filetypes = {
  'ClangdAST',
  'DressingInput',
  'Trouble',
  'checkhealth',
  'dap-repl',
  'dapui_breakpoints',
  'dapui_console',
  'dapui_scopes',
  'dapui_stacks',
  'dapui_watches',
  'edgy',
  'help',
  'lazy',
  'leetcode.nvim',
  'lspinfo',
  'man',
  'mason',
  'minifiles',
  'neo-tree',
  'noice',
  'qf',
  'query',
  'sagafinder',
  'sagaoutline',
  'spectre_panel',
  'ssr',
  'toggleterm',
}

M.rainbow_highlight = {
  'RainbowDelimiterRed',
  'RainbowDelimiterYellow',
  'RainbowDelimiterBlue',
  'RainbowDelimiterOrange',
  'RainbowDelimiterGreen',
  'RainbowDelimiterViolet',
  'RainbowDelimiterCyan',
}

return M
