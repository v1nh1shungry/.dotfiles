local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("dotfiles.utils." .. k)
    return t[k]
  end,
})

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

M.augroup = function(name)
  return vim.api.nvim_create_augroup("dotfiles_" .. name, {})
end

M.is_git_repo = function()
  return vim.fs.root(vim.uv.cwd() or 0, ".git")
end

return M
