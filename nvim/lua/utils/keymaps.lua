local M = {}

local map = function(opts)
  opts = vim.deepcopy(opts)
  local lhs, rhs, mode = opts[1], opts[2], opts.mode
  opts[1], opts[2], opts.mode = nil, nil, nil
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.map = function(opts)
  map(vim.tbl_extend('keep', opts, {
    mode = '',
    silent = true,
    unique = true,
  }))
end

M.nmap = function(opts)
  M.map(vim.tbl_extend('keep', opts, { mode = 'n' }))
end

M.vmap = function(opts)
  M.map(vim.tbl_extend('keep', opts, { mode = 'v' }))
end

M.imap = function(opts)
  M.map(vim.tbl_extend('keep', opts, { mode = 'i' }))
end

M.cmap = function(opts)
  M.map(vim.tbl_extend('keep', opts, { mode = 'c', silent = false }))
end

M.tmap = function(opts)
  M.map(vim.tbl_extend('keep', opts, { mode = 't' }))
end

M.xmap = function(opts)
  M.map(vim.tbl_extend('keep', opts, { mode = 'x' }))
end

M.noremap = function(opts)
  map(vim.tbl_extend('keep', opts, {
    mode = '',
    noremap = true,
    silent = true,
  }))
end

M.nnoremap = function(opts)
  M.noremap(vim.tbl_extend('keep', opts, { mode = 'n' }))
end

M.vnoremap = function(opts)
  M.noremap(vim.tbl_extend('keep', opts, { mode = 'v' }))
end

M.inoremap = function(opts)
  M.noremap(vim.tbl_extend('keep', opts, { mode = 'i' }))
end

M.cnoremap = function(opts)
  M.noremap(vim.tbl_extend('keep', opts, { mode = 'c', silent = false }))
end

M.tnoremap = function(opts)
  M.noremap(vim.tbl_extend('keep', opts, { mode = 't' }))
end

M.xnoremap = function(opts)
  M.noremap(vim.tbl_extend('keep', opts, { mode = 'x' }))
end

return M
