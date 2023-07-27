local M = {}

local extract = function(opts)
  local from, to = opts[1], opts[2]
  opts[1], opts[2] = nil, nil
  return from, to
end

local map = function(opts, mode, noremap)
  local from, to = extract(opts)
  vim.keymap.set(mode, from, to, vim.tbl_extend('keep', opts, {
    silent = true,
    noremap = noremap,
  }))
end

M.nmap = function(opts) map(opts, 'n') end

M.vmap = function(opts) map(opts, 'v') end

M.imap = function(opts) map(opts, 'i') end

M.cmap = function(opts) map(opts, 'i') end

M.tmap = function(opts) map(opts, 't') end

M.xmap = function(opts) map(opts, 'x') end

M.map = function(opts) map(opts, '') end

M.nnoremap = function(opts) map(opts, 'n', true) end

M.vnoremap = function(opts) map(opts, 'v', true) end

M.inoremap = function(opts) map(opts, 'i', true) end

M.cnoremap = function(opts) map(opts, 'c', true) end

M.tnoremap = function(opts) map(opts, 't', true) end

M.xnoremap = function(opts) map(opts, 'x', true) end

M.noremap = function(opts) map(opts, '', true) end

return M
