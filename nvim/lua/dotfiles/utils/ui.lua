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

-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/ui.lua {{{
local skip_foldexpr = {}
local skip_check = assert(vim.uv.new_check())

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  if skip_foldexpr[buf] then
    return "0"
  end

  if vim.bo[buf].buftype ~= "" then
    return "0"
  end

  if vim.bo[buf].filetype == "" then
    return "0"
  end

  if pcall(vim.treesitter.get_parser, buf) then
    return vim.treesitter.foldexpr()
  end

  skip_foldexpr[buf] = true
  skip_check:start(function()
    skip_foldexpr = {}
    skip_check:stop()
  end)

  return "0"
end
-- }}}

return M
