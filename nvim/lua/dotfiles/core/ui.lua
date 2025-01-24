local config = require("dotfiles.user")

vim.diagnostic.config({
  severity_sort = true,
  signs = false,
  jump = { float = true },
  update_in_insert = true,
})

for name, icon in pairs(Dotfiles.ui.icons.diagnostic) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { texthl = name, text = icon, numhl = "" })
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

vim.deprecate = function() end
