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
  lspkind = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
}

M.excluded_buftypes = { "nofile", "help", "prompt", "quickfix", "terminal" }

return M
