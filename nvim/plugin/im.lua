-- Inspired by https://github.com/keaising/im-select.nvim
if vim.fn.has("wsl") == 0 and vim.uv.os_uname().sysname ~= "Linux" then
  return
end

local command
local default_im

if vim.fn.has("wsl") ~= 0 then
  command = "im-select.exe"
  default_im = "1033"
else
  command = "fcitx-remote"
  default_im = "1"
end

if vim.fn.executable(command) == 0 then
  return
end

local previous_im

local function restore_default_im()
  Dotfiles.async.run(function()
    local ret = Dotfiles.async.system({ command }, { text = true })
    previous_im = vim.trim(ret.stdout)
    if vim.fn.has("wsl") == 0 then
      if default_im == "1" then
        vim.system({ command, "-c" })
      else
        vim.system({ command, "-o" })
      end
    else
      vim.system({ command, default_im })
    end
  end)
end

local function restore_previous_im()
  Dotfiles.async.run(function()
    local ret = Dotfiles.async.system({ command }, { text = true })
    if ret.stdout == previous_im then
      return
    end
    if vim.fn.has("wsl") == 0 then
      if previous_im == "1" then
        vim.system({ command, "-c" })
      elseif previous_im == "2" then
        vim.system({ command, "-o" })
      end
    else
      vim.system({ command, previous_im })
    end
  end)
end

local augroup = Dotfiles.augroup("im_switcher")

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = restore_previous_im,
  group = augroup,
})
vim.api.nvim_create_autocmd({ "VimEnter", "InsertLeave" }, {
  callback = restore_default_im,
  group = augroup,
})
