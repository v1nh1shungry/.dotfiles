local M = {}

M.icons = {
  diagnostic = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = "",
  },
  dap = {
    Breakpoint = { "󰝥", "DiagnosticError" },
    BreakpointCondition = "",
    BreakpointRejected = { "", "DiagnosticError" },
    LogPoint = "",
    Stopped = { "󰁕", "DiagnosticWarn", "DapStoppedLine" },
  },
}

M.excluded_buftypes = { "nofile", "help", "prompt", "quickfix", "terminal" }

return M
