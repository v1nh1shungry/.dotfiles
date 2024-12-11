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

-- https://www.lazyvim.org/ {{{
local notifs = {}
local function temp(...)
  table.insert(notifs, vim.F.pack_len(...))
end

local orig = vim.notify
vim.notify = temp

local timer = vim.uv.new_timer()
local check = assert(vim.uv.new_check())

local replay = function()
  timer:stop()
  check:stop()
  if vim.notify == temp then
    vim.notify = orig -- put back the original notify if needed
  end
  vim.schedule(function()
    ---@diagnostic disable-next-line: no-unknown
    for _, notif in ipairs(notifs) do
      vim.notify(vim.F.unpack_len(notif))
    end
  end)
end

-- wait till vim.notify has been replaced
check:start(function()
  if vim.notify ~= temp then
    replay()
  end
end)
-- or if it took more than 500ms, then something went wrong
timer:start(500, 0, replay)
-- }}}
