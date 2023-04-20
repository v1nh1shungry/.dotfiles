local M = {}

M.nmap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('n', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.vmap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('v', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.imap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('i', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.cmap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('c', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.tmap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('t', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.xmap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('x', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.map = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.nnoremap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('n', from, to, vim.tbl_extend('keep', opts, { noremap = true, silent = true }))
end

M.vnoremap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('v', from, to, vim.tbl_extend('keep', opts, { noremap = true, silent = true }))
end

M.inoremap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('i', from, to, vim.tbl_extend('keep', opts, { noremap = true, silent = true }))
end

M.cnoremap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('c', from, to, vim.tbl_extend('keep', opts, { noremap = true, silent = true }))
end

M.tnoremap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('t', from, to, vim.tbl_extend('keep', opts, { noremap = true, silent = true }))
end

M.xnoremap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('x', from, to, vim.tbl_extend('keep', opts, { noremap = true, silent = true }))
end

M.noremap = function(from, to, opts)
  opts = opts or {}
  vim.keymap.set('', from, to, vim.tbl_extend('keep', opts, { noremap = true, silent = true }))
end

return M
