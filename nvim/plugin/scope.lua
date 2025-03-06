local augroup = Dotfiles.augroup("scope")

---@class dotfiles.Scope
---@field __data table<integer, integer[]>
local M = setmetatable({ __data = {} }, {
  __index = function(self, k)
    if type(k) == "number" then
      if not self.__data[k] then
        self.__data[k] = {}
      end
      return self.__data[k]
    end
  end,
})

---@param buf integer
function M:add(buf)
  table.insert(self[vim.api.nvim_get_current_tabpage()], buf)
end

---@param buf integer
function M:del(buf)
  local tab = vim.api.nvim_get_current_tabpage()
  self[tab] = vim
    .iter(self[tab])
    :filter(function(b)
      return b ~= buf
    end)
    :totable()
end

vim.api.nvim_create_autocmd("BufAdd", {
  callback = function(args)
    if not vim.bo[args.buf].buflisted then
      return
    end
    M:add(args.buf)
  end,
  group = augroup,
})

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(args)
    if not vim.bo[args.buf].buflisted then
      return
    end
    M:del(args.buf)
  end,
  group = augroup,
})

vim.api.nvim_create_autocmd("OptionSet", {
  callback = function(args)
    if vim.bo[args.buf] then
      M:add(args.buf)
    else
      M:del(args.buf)
    end
  end,
  group = augroup,
  pattern = "buftype",
})

vim.api.nvim_create_autocmd("TabEnter", {
  callback = function()
    local tab = vim.api.nvim_get_current_tabpage()
    vim
      .iter(M[tab] or {})
      :filter(vim.api.nvim_buf_is_valid)
      :each(function(b)
        vim.bo[b].buflisted = true
      end)
  end,
  group = augroup,
})

vim.api.nvim_create_autocmd("TabLeave", {
  callback = function()
    local tab = vim.api.nvim_get_current_tabpage()
    vim
      .iter(M[tab] or {})
      :filter(vim.api.nvim_buf_is_valid)
      :each(function(b)
        vim.bo[b].buflisted = false
      end)
  end,
  group = augroup,
})
