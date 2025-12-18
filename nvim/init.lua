if vim.env.PROFILE_STARTUP then
  vim.opt.rtp:append(vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "snacks.nvim"))
  ---@diagnostic disable-next-line: missing-parameter
  require("snacks.profiler").startup()
end

_G.Dotfiles = require("dotfiles.utils")

-- https://www.lazyvim.org/ {{{
do
  local notifs = {}
  local function temp(...) table.insert(notifs, vim.F.pack_len(...)) end

  local orig = vim.notify
  vim.notify = temp

  local timer = assert(vim.uv.new_timer())
  local check = vim.uv.new_check()

  local replay = function()
    timer:stop()
    check:stop()

    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end

    vim.schedule(function()
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- Wait until vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- Or if it took more than 1s, then something went wrong
  timer:start(1000, 0, replay)
end
-- }}}

require("dotfiles.core.autocmds")
require("dotfiles.core.keymaps")
require("dotfiles.core.options")
require("dotfiles.core.lazy")

-- Clean loader cache for files that no longer exist.
local luac_path = vim.fs.joinpath(vim.fn.stdpath("cache"), "luac")
for name, type in vim.fs.dir(luac_path) do
  if type == "file" then
    if not vim.uv.fs_stat(vim.uri_decode(name):sub(1, -2)) then
      vim.fs.rm(vim.fs.joinpath(luac_path, name))
    end
  end
end

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = { "", "", "", "" },
  },
})

vim.cmd("colorscheme " .. Dotfiles.user.colorscheme)

for k, v in pairs(Dotfiles.user.env) do
  vim.env[k] = v
end
