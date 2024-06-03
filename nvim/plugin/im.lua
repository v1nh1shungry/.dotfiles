if vim.fn.has("wsl") == 0 then
  return
end

local command = "im-select.exe"
local default_im = "1033"

if vim.fn.executable(command) == 0 then
  return
end

local previous_im

local function restore_default_im()
  vim.system(
    { command },
    { text = true },
    vim.schedule_wrap(function(obj)
      previous_im = obj.stdout
      vim.system({ command, default_im })
    end)
  )
end

local function restore_previous_im()
  vim.system(
    { command },
    { text = true },
    vim.schedule_wrap(function(obj)
      if obj.stdout ~= previous_im then
        vim.system({ command, previous_im })
      end
    end)
  )
end

local augroup = vim.api.nvim_create_augroup("hero_im_autocmd", {})

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
})
