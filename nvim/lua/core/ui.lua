local icons = require('utils.ui').icons

for name, icon in pairs {
    DiagnosticSignError = icons.diagnostic.error,
    DiagnosticSignWarn = icons.diagnostic.warn,
    DiagnosticSignHint = icons.diagnostic.hint,
    DiagnosticSignInfo = icons.diagnostic.info,
  } do
    vim.fn.sign_define(name, { texthl = name, text = icon, numhl = '' })
  end

  vim.fn.sign_define('DapBreakpoint', {
    text = icons.dap.breakpoint,
    texthl = 'DiagnosticSignError',
    linehl = '',
    numhl = '',
  })
  vim.fn.sign_define('DapBreakpointCondition', {
    text = icons.dap.breakpoint_condition,
    texthl = 'DiagnosticSignError',
    linehl = '',
    numhl = '',
  })
  vim.fn.sign_define('DapBreakpointRejected', {
    text = icons.dap.breakpoint_rejected,
    texthl = 'DapBreakpoint',
    linehl = '',
    numhl = '',
  })
  vim.fn.sign_define('DapLogPoint', {
    text = icons.dap.log_point,
    texthl = 'DiagnosticSignError',
    linehl = '',
    numhl = '',
  })
  vim.fn.sign_define('DapStopped', {
    text = icons.dap.stopped,
    texthl = 'DapStopped',
    linehl = '',
    numhl = '',
  })
