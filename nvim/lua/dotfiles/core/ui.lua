local icons = require("dotfiles.utils.ui").icons
local config = require("dotfiles.user")

vim.diagnostic.config({
  severity_sort = true,
  signs = false,
  float = { border = "rounded" },
  jump = { float = true },
  update_in_insert = true,
})

for name, icon in pairs(icons.diagnostic) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { texthl = name, text = icon, numhl = "" })
end

vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

for name, sign in pairs(icons.dap) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define(
    "Dap" .. name,
    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  )
end

local background = config.ui.background
if type(background) == "table" then
  local t = os.date("*t", os.time())
  vim.opt.background = (background.light <= t.hour and t.hour < background.dark) and "light" or "dark"
else
  vim.opt.background = background
end

vim.cmd("colorscheme " .. config.ui.colorscheme)
