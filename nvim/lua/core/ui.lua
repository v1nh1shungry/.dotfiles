local icons = require("utils.ui").icons
local config = require("user")

vim.diagnostic.config({
  virtual_text = { spacing = 4, source = "if_many" },
  severity_sort = true,
  signs = false,
  update_in_insert = true,
  float = { border = "rounded" },
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
  vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter" }, {
    callback = function()
      local t = os.date("*t", os.time())
      vim.opt.background = (background.light <= t.hour and t.hour < background.dark) and "light" or "dark"
    end,
  })
else
  vim.opt.background = background
end

vim.cmd("colorscheme " .. config.ui.colorscheme)
