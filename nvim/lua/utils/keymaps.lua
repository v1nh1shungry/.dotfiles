local M = {}

local extract = function(opts)
  local from, to = opts[1], opts[2]
  opts[1], opts[2] = nil, nil
  return from, to
end

M.nmap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('n', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.vmap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('v', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.imap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('i', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.cmap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('i', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.tmap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('t', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.xmap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('x', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.map = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('', from, to, vim.tbl_extend('keep', opts, { silent = true }))
end

M.nnoremap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('n', from, to, vim.tbl_extend('keep', opts, { silent = true, noremap = true }))
end

M.vnoremap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('v', from, to, vim.tbl_extend('keep', opts, { silent = true, noremap = true }))
end

M.inoremap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('i', from, to, vim.tbl_extend('keep', opts, { silent = true, noremap = true }))
end

M.cnoremap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('c', from, to, vim.tbl_extend('keep', opts, { silent = true, noremap = true }))
end

M.tnoremap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('t', from, to, vim.tbl_extend('keep', opts, { silent = true, noremap = true }))
end

M.xnoremap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('x', from, to, vim.tbl_extend('keep', opts, { silent = true, noremap = true }))
end

M.noremap = function(opts)
  local from, to = extract(opts)
  vim.keymap.set('', from, to, vim.tbl_extend('keep', opts, { silent = true, noremap = true }))
end

return M
