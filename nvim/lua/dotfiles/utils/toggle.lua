local M = {}

function M.quickfix()
  local nr = vim.fn.winnr("$")
  vim.cmd("cwindow")
  if nr == vim.fn.winnr("$") then
    vim.cmd("cclose")
  end
end

function M.location()
  local nr = vim.fn.winnr("$")
  vim.cmd("lwindow")
  if nr == vim.fn.winnr("$") then
    vim.cmd("lclose")
  end
end

local maximized = nil
function M.maximize()
  if maximized then
    vim.o.winwidth = maximized.width
    vim.o.winheight = maximized.height
    maximized = nil
    vim.cmd("wincmd =")
  else
    maximized = {
      width = vim.o.winwidth,
      height = vim.o.winheight,
    }
    vim.o.winwidth = 999
    vim.o.winheight = 999
  end
end

return M
