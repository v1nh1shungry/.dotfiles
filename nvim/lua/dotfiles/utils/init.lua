---@class dotfiles.utils
---@field co dotfiles.utils.Co
---@field lsp dotfiles.utils.LSP
---@field ui dotfiles.utils.UI
---@field user dotfiles.user.Config
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("dotfiles.utils." .. k)
    return t[k]
  end,
})

---@class dotfiles.map.Opts: vim.keymap.set.Opts
---@field [1] string
---@field [2] string|function
---@field mode? string|string[]
---
---@param opts dotfiles.map.Opts
M.map = function(opts)
  opts = vim.deepcopy(opts)
  local lhs, rhs, mode = opts[1], opts[2], opts.mode or "n"
  opts[1], opts[2], opts.mode = nil, nil, nil
  mode = type(mode) == "table" and mode or { mode }
  if vim.list_contains(mode, "c") then
    mode = vim.tbl_filter(function(m)
      return m ~= "c"
    end, mode)
    vim.keymap.set("c", lhs, rhs, vim.tbl_extend("force", opts, { silent = false }))
  end
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

---@param name string
---@param opts? vim.api.keyset.create_augroup
---@return integer
M.augroup = function(name, opts)
  return vim.api.nvim_create_augroup("dotfiles." .. name, opts or {})
end

---@param name string
---@return integer
M.ns = function(name)
  return vim.api.nvim_create_namespace("dotfiles." .. name)
end

---@return string?
M.git_root = function()
  return vim.fs.root(vim.fn.getcwd(), ".git")
end

return M
