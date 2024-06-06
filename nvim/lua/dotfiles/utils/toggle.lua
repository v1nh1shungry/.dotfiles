local M = {}

---@param silent boolean?
---@param values { [1]: any, [2]:any }?
---@return fun()
function M.option(option, silent, values)
  return function()
    if values then
      if vim.opt_local[option]:get() == values[1] then
        vim.opt_local[option] = values[2]
      else
        vim.opt_local[option] = values[1]
      end
      if not silent then
        vim.notify("Set " .. option .. " to " .. vim.opt_local[option]:get(), vim.log.levels.INFO, { title = "Option" })
      end
    else
      vim.opt_local[option] = not vim.opt_local[option]:get()
      if not silent then
        vim.notify(
          (vim.opt_local[option]:get() and "Enabled " or "Disabled ") .. option,
          vim.log.levels.INFO,
          { title = "Option" }
        )
      end
    end
  end
end

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

function M.diagnostic() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end

function M.inlay_hint() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end

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
