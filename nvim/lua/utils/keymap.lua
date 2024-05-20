return function(opts)
  local lhs, rhs, mode = opts[1], opts[2], opts.mode or 'n'
  opts[1], opts[2], opts.mode = nil, nil, nil
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end
