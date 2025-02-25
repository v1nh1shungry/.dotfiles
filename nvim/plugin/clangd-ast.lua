-- TODO: refactor

-- Modified from https://github.com/p00f/clangd_extensions.nvim/blob/main/lua/clangd_extensions/ast.lua {{{
local NS_ID = Dotfiles.ns("lsp.clangd.ast")
local ICONS = {
  role = {
    type = "",
    declaration = "",
    expression = "",
    specifier = "",
    statement = "",
    ["template argument"] = "",
  },
  kind = {
    Compound = "",
    Recovery = "",
    TranslationUnit = "",
    PackExpansion = "",
    TemplateTypeParm = "",
    TemplateTemplateParm = "",
    TemplateParamObject = "",
  },
}

local node_pos = {}
local detail_pos = {}

local function clear_highlight(source_buf)
  vim.api.nvim_buf_clear_namespace(source_buf, NS_ID, 0, -1)
end

local function update_highlight(source_buf, ast_buf)
  clear_highlight(source_buf)

  if vim.api.nvim_get_current_buf() ~= ast_buf then
    return
  end

  local curline = vim.fn.getcurpos()[2]
  local curline_ranges = node_pos[source_buf][ast_buf][curline]
  if curline_ranges then
    vim.hl.range(source_buf, NS_ID, "Search", curline_ranges.start, curline_ranges["end"], {
      regtype = "v",
      inclusive = false,
      priority = 110,
    })
  end
end

local function setup_hl_autocmd(source_buf, ast_buf)
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = ast_buf,
    callback = function()
      update_highlight(source_buf, ast_buf)
    end,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = ast_buf,
    callback = function()
      clear_highlight(source_buf)
    end,
  })
end

local function icon_prefix(role, kind)
  if ICONS.kind[kind] then
    return ICONS.kind[kind] .. "  "
  elseif ICONS.role[role] then
    return ICONS.role[role] .. "  "
  else
    return "   "
  end
end

local function describe(role, kind, detail)
  local icon = icon_prefix(role, kind)
  local detailpos
  local str = kind

  if not (role == "expression" or role == "statement" or role == "declaration" or role == "template name") then
    str = str .. " " .. role
  end

  if detail then
    detailpos = {
      start = string.len(str) + vim.fn.strlen(icon) + 1,
      ["end"] = string.len(str) + vim.fn.strlen(icon) + string.len(detail) + 1,
    }
    str = str .. " " .. detail
  end

  return (icon .. str), detailpos
end

local function walk_tree(node, visited, result, padding, hl_bufs)
  visited[node] = true
  local str, detpos = describe(node.role, node.kind, node.detail)
  table.insert(result, padding .. str)

  if node.detail and detpos then
    detail_pos[hl_bufs.ast_buf][#result] = {
      start = string.len(padding) + detpos.start,
      ["end"] = string.len(padding) + detpos["end"],
    }
  end

  if node.range then
    node_pos[hl_bufs.source_buf][hl_bufs.ast_buf][#result] = {
      start = { node.range.start.line, node.range.start.character },
      ["end"] = { node.range["end"].line, node.range["end"].character },
    }
  end

  if node.children then
    for _, child in pairs(node.children) do
      if not visited[child] then
        walk_tree(child, visited, result, padding .. "  ", hl_bufs)
      end
    end
  end

  return result
end

local function highlight_detail(ast_buf)
  for linenum, range in pairs(detail_pos[ast_buf]) do
    vim.hl.range(ast_buf, NS_ID, "Comment", { linenum - 1, range.start }, { linenum - 1, range["end"] }, {
      regtype = "v",
      inclusive = false,
      priority = 110,
    })
  end
end

local function handler(err, node)
  if err or not node then
    return
  end

  local source_buf = vim.api.nvim_get_current_buf()
  local b = vim.b[source_buf]

  if not b.clangd_ast_buf or not vim.api.nvim_buf_is_valid(b.clangd_ast_buf) then
    b.clangd_ast_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[b.clangd_ast_buf].filetype = "ClangdAST"
    vim.bo[b.clangd_ast_buf].shiftwidth = 2
  end

  if not b.clangd_ast_win or not vim.api.nvim_win_is_valid(b.clangd_ast_win) then
    b.clangd_ast_win = vim.api.nvim_open_win(b.clangd_ast_buf, true, { split = "right" })
  else
    vim.cmd(vim.api.nvim_win_get_number(b.clangd_ast_win) .. " wincmd w")
  end

  if not node_pos[source_buf] then
    node_pos[source_buf] = {}
  end

  node_pos[source_buf][b.clangd_ast_buf] = {}
  detail_pos[b.clangd_ast_buf] = {}

  local lines = walk_tree(node, {}, {}, "", { source_buf = source_buf, ast_buf = b.clangd_ast_buf })
  vim.bo.modifiable = true
  vim.api.nvim_buf_set_lines(b.clangd_ast_buf, 0, -1, true, lines)
  vim.bo.modifiable = false
  setup_hl_autocmd(source_buf, b.clangd_ast_buf)
  highlight_detail(b.clangd_ast_buf)
end

Dotfiles.lsp.on_attach(function(client, bufnr)
  if client.name ~= "clangd" then
    return
  end

  Dotfiles.map({
    "<Leader>cA",
    function()
      vim.lsp.buf_request(bufnr, "textDocument/ast", {
        textDocument = { uri = vim.uri_from_bufnr(0) },
        range = {
          start = { line = 0, character = 0 },
          ["end"] = { line = vim.api.nvim_buf_line_count(0), character = 0 },
        },
      }, handler)
    end,
    desc = "Clangd AST",
  })
end)
-- }}}
