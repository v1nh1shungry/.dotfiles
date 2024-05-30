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

M.excluded_filetypes = {
  "ClangdAST",
  "DressingInput",
  "Glance",
  "TelescopePrompt",
  "checkhealth",
  "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  "edgy",
  "help",
  "lazy",
  "leetcode.nvim",
  "lspinfo",
  "man",
  "mason",
  "minifiles",
  "minifiles-help",
  "noice",
  "notify",
  "qf",
  "sagafinder",
  "sagaoutline",
  "ssr",
  "toggleterm",
  "trouble",
}

M.excluded_buftypes = { "nofile", "help", "quickfix", "terminal" }

M.rainbow_highlight = {
  "RainbowDelimiterRed",
  "RainbowDelimiterYellow",
  "RainbowDelimiterBlue",
  "RainbowDelimiterOrange",
  "RainbowDelimiterGreen",
  "RainbowDelimiterViolet",
  "RainbowDelimiterCyan",
}

return M
