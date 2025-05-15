-- Inspired by https://github.com/keaising/im-select.nvim
if vim.uv.os_uname().sysname ~= "Linux" then return end

local command = "fcitx-remote"
local default_im = "1"

if vim.fn.executable(command) == 0 then
  command = "fcitx5-remote"
  if vim.fn.executable(command) == 0 then return end
end

local previous_im

---@async
local function restore_default_im()
  local ret = Dotfiles.co.system({ command }, { text = true })
  previous_im = vim.trim(ret.stdout)
  if default_im == "1" then
    Dotfiles.co.system({ command, "-c" })
  else
    Dotfiles.co.system({ command, "-o" })
  end
end

---@async
local function restore_previous_im()
  local ret = Dotfiles.co.system({ command }, { text = true })
  if ret.stdout == previous_im then return end
  if previous_im == "1" then
    Dotfiles.co.system({ command, "-c" })
  elseif previous_im == "2" then
    Dotfiles.co.system({ command, "-o" })
  end
end

local AUGROUP = Dotfiles.augroup("im_switcher")

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  callback = Dotfiles.co.void(restore_previous_im),
  group = AUGROUP,
})
vim.api.nvim_create_autocmd({ "VimEnter", "InsertLeave", "CmdlineLeave" }, {
  callback = Dotfiles.co.void(restore_default_im),
  group = AUGROUP,
})
