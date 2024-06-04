local ID = "DEBUGPRINT"

local filetype_assets = {
  cpp = {
    treesitter_query = { "identifier" },
    template = [[std::cerr << "[%s " << %s << ':' << %s << "] " << %%s << std::endl;]],
    file = "__FILE__",
    line = "__LINE__",
    var = [["%s = " << %s]],
  },
  lua = {
    treesitter_query = { "identifier" },
    template = [[print("[%s", %s .. ":" .. %s .. "]", %%s)]],
    file = "debug.getinfo(1).source:sub(2)",
    line = "debug.getinfo(1).currentline",
    var = [["%s =", vim.inspect(%s)]],
  },
}

local function debugprint(filetype, item, var, above)
  local asset = filetype_assets[filetype]
  if var then
    item = asset.var:format(item, item)
  else
    item = ([["%s %s"]]):format(above and "before" or "after", item)
  end
  return asset.template:format(ID, asset.file, asset.line):format(item)
end

local function plain(above)
  local line = vim.trim(vim.api.nvim_get_current_line())
  local linenr, _ = unpack(vim.api.nvim_win_get_cursor(0))
  if above then
    linenr = linenr - 1
  end
  vim.api.nvim_buf_set_lines(0, linenr, linenr, true, { debugprint(vim.bo.filetype, line, false, above) })
  vim.cmd(linenr + 1 .. "normal! ==")
end

local function variable(above)
  local node = vim.treesitter.get_node()
  if node == nil or not vim.tbl_contains(filetype_assets[vim.bo.filetype].treesitter_query, node:type()) then
    vim.notify("No variable under the cursor", vim.log.levels.ERROR, { title = "debugprint" })
    return
  end
  local linenr, _ = unpack(vim.api.nvim_win_get_cursor(0))
  if above then
    linenr = linenr - 1
  end
  vim.api.nvim_buf_set_lines(
    0,
    linenr,
    linenr,
    true,
    { debugprint(vim.bo.filetype, vim.treesitter.get_node_text(node, 0), true, above) }
  )
  vim.cmd(linenr + 1 .. "normal! ==")
end

local function toggle()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  for i, l in ipairs(lines) do
    if l:find(ID) then
      vim.cmd(i .. "norm gcc")
    end
  end
end

local function delete()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local delete_count = 0
  for i, l in ipairs(lines) do
    if l:find(ID) then
      local linenr = i - delete_count - 1
      vim.api.nvim_buf_set_lines(0, linenr, linenr + 1, false, {})
      delete_count = delete_count + 1
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    local map = function(key)
      key.buffer = event.buf
      require("hero.utils.keymap")(key)
    end

    map({ "<Leader>dpp", plain, desc = "Plain debugprint (below)" })
    map({ "<Leader>dpP", function() plain(true) end, desc = "Plain debuprint (above)" })
    map({ "<Leader>dpv", variable, desc = "Variable debugprint (below)" })
    map({ "<Leader>dpV", function() variable(true) end, desc = "Variable debuprint (above)" })
    map({ "<Leader>dpt", toggle, desc = "Toggle debugprint" })
    map({ "<Leader>dpd", delete, desc = "Delete debugprint" })
  end,
  group = vim.api.nvim_create_augroup("hero_debugprint_autocmds", {}),
  pattern = vim.tbl_keys(filetype_assets),
})
