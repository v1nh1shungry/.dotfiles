local map = require("dotfiles.utils.keymap")

local marker = "<!-- markdown-toc -->"

local function toc(start_linenr, end_linenr)
  local parser = vim.treesitter.get_parser(0, "markdown")
  local root = parser:parse()[1]:root()
  local query = vim.treesitter.query.parse(
    "markdown",
    [[
(atx_heading) @header
    ]]
  )
  local lines = { marker }
  for _, node in query:iter_captures(root, 0, end_linenr) do
    local level = tonumber(node:child(0):type():match("atx_h(%d)_marker")) - 2
    if level >= 0 then
      local title = vim.treesitter.get_node_text(node:field("heading_content")[1], 0)
      local anchor = title:gsub("%s+", "-"):lower()
      if anchor:find("[\u{FE0F}]") then
        anchor = anchor:gsub("[\u{FE0F}]", ""):gsub("[\u{1F600}-\u{1F64F}]", function() return "%EF%B8%8F" end, 1)
      end
      anchor = anchor:gsub("[\u{1F600}-\u{1F64F}]", "")
      lines[#lines + 1] = ("  "):rep(level) .. ("* [%s](#%s)"):format(title, anchor)
    end
  end
  lines[#lines + 1] = marker
  vim.api.nvim_buf_set_lines(0, start_linenr, end_linenr, true, lines)
end

local function update()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local start_linenr, end_linenr
  for i, line in ipairs(lines) do
    if line == marker then
      if not start_linenr then
        start_linenr = i - 1
      elseif not end_linenr then
        end_linenr = i
        break
      end
    end
  end
  if not (start_linenr and end_linenr) then
    return
  end
  toc(start_linenr, end_linenr)
end

local augroup = vim.api.nvim_create_augroup("dotfiles_markdown_toc_autocmds", {})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    map({
      "<Leader>cT",
      function()
        local current_linenr = vim.api.nvim_win_get_cursor(0)[1] - 1
        toc(current_linenr, current_linenr)
      end,
      buffer = event.buf,
      desc = "Generate TOC",
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = event.buf,
      callback = update,
      group = augroup,
    })
  end,
  group = augroup,
  pattern = "markdown",
})
