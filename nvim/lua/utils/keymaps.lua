local M = {}

M.nmap = function(from, to)
  vim.keymap.set('n', from, to, { silent = true })
end

M.vmap = function(from, to)
  vim.keymap.set('v', from, to, { silent = true })
end

M.imap = function(from, to)
  vim.keymap.set('i', from, to, { silent = true })
end

M.cmap = function(from, to)
  vim.keymap.set('c', from, to)
end

M.tmap = function(from, to)
  vim.keymap.set('t', from, to, { silent = true })
end

M.xmap = function(from, to)
  vim.keymap.set('x', from, to, { silent = true })
end

M.map = function(from, to)
  vim.keymap.set('', from, to, { silent = true })
end

M.nnoremap = function(from, to)
  vim.keymap.set('n', from, to, { noremap = true, silent = true })
end

M.vnoremap = function(from, to)
  vim.keymap.set('v', from, to, { noremap = true, silent = true })
end

M.inoremap = function(from, to)
  vim.keymap.set('i', from, to, { noremap = true, silent = true })
end

M.cnoremap = function(from, to)
  vim.keymap.set('c', from, to, { noremap = true })
end

M.tnoremap = function(from, to)
  vim.keymap.set('t', from, to, { noremap = true, silent = true })
end

M.xnoremap = function(from, to)
  vim.keymap.set('x', from, to, { noremap = true, silent = true })
end

M.noremap = function(from, to)
  vim.keymap.set('', from, to, { noremap = true, silent = true })
end

return M
