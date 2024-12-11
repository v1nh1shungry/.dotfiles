return function(opts)
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
