local nnoremap = require('utils.keymaps').nnoremap

local ID = 'DEBUGPRINT'

---@type table<string, fun(string, boolean): string>
local filetype_snippet = {
  cpp = function(item, var)
    local template = 'std::cerr << "[' .. ID .. ' " << __FILE__ << ":" << __LINE__ << "] "<< %s << std::endl;'
    if var then
      return template:format(string.format('"%s = " << %s', item, item))
    else
      return template:format('"after ' .. item .. '"')
    end
  end,
  lua = function(item, var)
    local source = 'debug.getinfo(1).source:sub(2)'
    local linenr = 'debug.getinfo(1).currentline'
    local template = "print('[" .. ID .. "', " .. source .. " .. ':' .. " .. linenr .. " .. ']', %s)"
    if var then
      return template:format(string.format("'%s =', vim.inspect(%s)", item, item))
    else
      return template:format('"after ' .. item .. '"')
    end
  end,
}

local filetype_variable = {
  cpp = { 'identifier' },
  lua = { 'identifier' },
}

local function plain()
  local line = vim.trim(vim.api.nvim_get_current_line())
  local linenr, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, linenr, linenr, true, { filetype_snippet[vim.bo.filetype](line, false) })
  vim.cmd(linenr + 1 .. 'normal! ==')
end

local function variable()
  local node = vim.treesitter.get_node()
  if node == nil or not vim.tbl_contains(filetype_variable[vim.bo.filetype], node:type()) then
    vim.notify('No variable under the cursor', vim.log.levels.ERROR, { title = 'debugprint' })
    return
  end
  local linenr, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(
    0,
    linenr,
    linenr,
    true,
    { filetype_snippet[vim.bo.filetype](vim.treesitter.get_node_text(node, 0), true) }
  )
  vim.cmd(linenr + 1 .. 'normal! ==')
end

local function toggle()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  for i, l in ipairs(lines) do
    if l:find(ID) then
      vim.cmd(i .. 'norm gcc')
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

nnoremap({ '<Leader>dpp', plain, desc = 'Plain debugprint' })
nnoremap({ '<Leader>dpv', variable, desc = 'Variable debugprint' })
nnoremap({ '<Leader>dpt', toggle, desc = 'Toggle debugprint' })
nnoremap({ '<Leader>dpd', delete, desc = 'Delete debugprint' })
