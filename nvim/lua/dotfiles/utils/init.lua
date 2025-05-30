---@class dotfiles.utils
---@field C dotfiles.utils.C
---@field co dotfiles.utils.Co
---@field git dotfiles.utils.Git
---@field notify dotfiles.utils.Notifier|dotfiles.utils.Notify
---@field user dotfiles.utils.User
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("dotfiles.utils." .. k)
    return t[k]
  end,
})

---@class dotfiles.utils.map.Opts: vim.keymap.set.Opts
---@field [1] string
---@field [2] string|function
---@field mode? string|string[]
---@field ft? string|string[]
---
---@param opts dotfiles.utils.map.Opts
function M.map(opts)
  opts = vim.deepcopy(opts)

  if opts.ft then
    local pattern = opts.ft
    opts.ft = nil

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args) Dotfiles.map_with({ buffer = args.buf })(opts) end,
      pattern = pattern,
    })

    return
  end

  local lhs, rhs, mode = opts[1], opts[2], opts.mode or "n"
  opts[1], opts[2], opts.mode = nil, nil, nil

  mode = type(mode) == "table" and mode or { mode }
  if vim.list_contains(mode, "c") then
    mode = vim.tbl_filter(function(m) return m ~= "c" end, mode)
    vim.keymap.set("c", lhs, rhs, vim.tbl_deep_extend("force", opts, { silent = false }))
  end

  opts.silent = opts.silent ~= false

  vim.keymap.set(mode, lhs, rhs, opts)
end

---@param opts vim.keymap.set.Opts
---@return fun(opts: dotfiles.utils.map.Opts)
function M.map_with(opts)
  return function(mapping) M.map(vim.tbl_deep_extend("force", opts, mapping)) end
end

---@param name string
---@param opts? vim.api.keyset.create_augroup
---@return integer
function M.augroup(name, opts) return vim.api.nvim_create_augroup("dotfiles." .. name, opts or {}) end

---@param name string
---@return integer
function M.ns(name) return vim.api.nvim_create_namespace("dotfiles." .. name) end

return M
