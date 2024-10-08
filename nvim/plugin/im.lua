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
  vim.system(
    { command },
    { text = true },
    vim.schedule_wrap(function(obj)
      previous_im = vim.trim(obj.stdout)
      if vim.fn.has("wsl") ~= 0 then
        vim.system({ command, default_im })
      else
        if default_im == "1" then
          vim.system({ command, "-c" })
        else
          vim.system({ command, "-o" })
        end
      end
    end)
  )
end

local function restore_previous_im()
  vim.system(
    { command },
    { text = true },
    vim.schedule_wrap(function(obj)
      if obj.stdout ~= previous_im then
        if vim.fn.has("wsl") ~= 0 then
          vim.system({ command, previous_im })
        else
          if previous_im == "1" then
            vim.system({ command, "-c" })
          elseif previous_im == "2" then
            vim.system({ command, "-o" })
          end
        end
      end
    end)
  )
end

local augroup = vim.api.nvim_create_augroup("dotfiles_im_autocmd", {})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = restore_previous_im,
  group = augroup,
})
vim.api.nvim_create_autocmd({ "VimEnter", "InsertLeave" }, {
  callback = restore_default_im,
  group = augroup,
})
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    if not vim.api.nvim_get_mode().mode:match("i") then
      restore_default_im()
    end
  end,
  group = augroup,
})
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    if vim.api.nvim_get_mode().mode:match("i") then
      restore_previous_im()
    end
  end,
  group = augroup,
})
