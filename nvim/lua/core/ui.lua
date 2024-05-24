local icons = require("utils.ui").icons
local config = require("user")

for name, icon in pairs({
  DiagnosticSignError = icons.diagnostic.error,
  DiagnosticSignWarn = icons.diagnostic.warn,
  DiagnosticSignHint = icons.diagnostic.hint,
  DiagnosticSignInfo = icons.diagnostic.info,
}) do
  vim.fn.sign_define(name, { texthl = name, text = icon, numhl = "" })
end

vim.fn.sign_define("DapBreakpoint", {
  text = icons.dap.breakpoint,
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapBreakpointCondition", {
  text = icons.dap.breakpoint_condition,
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = icons.dap.breakpoint_rejected,
  texthl = "DapBreakpoint",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapLogPoint", {
  text = icons.dap.log_point,
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapStopped", {
  text = icons.dap.stopped,
  texthl = "DapStopped",
  linehl = "",
  numhl = "",
})

local background = config.ui.background
if type(background) == "table" then
  local function update()
    local t = os.date("*t", os.time())
    vim.opt.background = (background.light <= t.hour and t.hour < background.dark) and "light" or "dark"
  end
  update()
  vim.api.nvim_create_autocmd("FocusGained", {
    callback = update,
    group = vim.api.nvim_create_augroup("dotfiles_auto_background", {}),
  })
else
  vim.opt.background = background
end

vim.cmd("colorscheme " .. config.ui.colorscheme)
