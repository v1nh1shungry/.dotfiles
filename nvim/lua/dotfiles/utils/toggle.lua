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
    for _, opt in ipairs(maximized) do
      vim.o[opt.k] = opt.v
    end
    maximized = nil
  else
    maximized = {}
    local function set(k, v)
      table.insert(maximized, 1, { k = k, v = vim.o[k] })
      vim.o[k] = v
    end
    set("winwidth", 999)
    set("winheight", 999)
    set("winminwidth", 10)
    set("winminheight", 4)
  end

  vim.cmd("wincmd =")
end

return M
