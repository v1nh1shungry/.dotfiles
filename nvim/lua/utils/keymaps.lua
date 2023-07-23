local M = {}

local extract = function(opts)
  local from, to = opts[1], opts[2]
  opts[1], opts[2] = nil, nil
  return from, to
end

M.nmap = function(opts)
  local from, to = extract(opts)
  opts.silent = true
  vim.keymap.set('n', from, to, opts)
end

M.vmap = function(opts)
  local from, to = extract(opts)
  opts.silent = true
  vim.keymap.set('v', from, to, opts)
end

M.imap = function(opts)
  local from, to = extract(opts)
  opts.silent = true
  vim.keymap.set('i', from, to, opts)
end

M.cmap = function(opts)
  local from, to = extract(opts)
  opts.silent = true
  vim.keymap.set('i', from, to, opts)
end

M.tmap = function(opts)
  local from, to = extract(opts)
  opts.silent = true
  vim.keymap.set('t', from, to, opts)
end

M.xmap = function(opts)
  local from, to = extract(opts)
  opts.silent = true
  vim.keymap.set('x', from, to, opts)
end

M.map = function(opts)
  local from, to = extract(opts)
  opts.silent = true
  vim.keymap.set('', from, to, opts)
end

M.nnoremap = function(opts)
  local from, to = extract(opts)
  opts.silent, opts.noremap = true, true
  vim.keymap.set('n', from, to, opts)
end

M.vnoremap = function(opts)
  local from, to = extract(opts)
  opts.silent, opts.noremap = true, true
  vim.keymap.set('v', from, to, opts)
end

M.inoremap = function(opts)
  local from, to = extract(opts)
  opts.silent, opts.noremap = true, true
  vim.keymap.set('i', from, to, opts)
end

M.cnoremap = function(opts)
  local from, to = extract(opts)
  opts.silent, opts.noremap = true, true
  vim.keymap.set('c', from, to, opts)
end

M.tnoremap = function(opts)
  local from, to = extract(opts)
  opts.silent, opts.noremap = true, true
  vim.keymap.set('t', from, to, opts)
end

M.xnoremap = function(opts)
  local from, to = extract(opts)
  opts.silent, opts.noremap = true, true
  vim.keymap.set('x', from, to, opts)
end

M.noremap = function(opts)
  local from, to = extract(opts)
  opts.silent, opts.noremap = true, true
  vim.keymap.set('', from, to, opts)
end

return M
