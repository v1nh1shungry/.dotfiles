---@class dotfiles.utils.LSP
local M = {}

-- Modified from https://github.com/nvimdev/lspsaga.nvim {{{
local peek_stack = {}

-- FIXME: restore buffer
function M.peek_definition()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _)
    if vim.islist(result) then
      result = result[1]
    end

    local buf = vim.uri_to_bufnr(result.targetUri or result.uri)
    local win_opts = {
      buf = buf,
      border = "rounded",
      height = math.floor(vim.o.lines * 0.5),
      position = "float",
      title = vim.api.nvim_buf_get_name(buf),
      title_pos = "center",
      width = math.floor(vim.o.columns * 0.6),
      zindex = 20,
    }

    if #peek_stack > 0 then
      local prev_conf = vim.api.nvim_win_get_config(peek_stack[#peek_stack])
      win_opts.col = prev_conf.col + 1
      win_opts.height = prev_conf.height - 1
      win_opts.row = prev_conf.row + 1
      win_opts.width = prev_conf.width - 2
    end

    local winid = Snacks.win(win_opts).win
    local range = result.targetSelectionRange or result.range
    vim.api.nvim_win_set_cursor(winid, {
      range.start.line + 1,
      vim.lsp.util._get_line_byte_from_position(buf, range.start, "utf-8"),
    })

    vim.api.nvim_create_autocmd("WinClosed", {
      callback = function()
        table.remove(peek_stack)
      end,
      pattern = tostring(winid),
    })

    peek_stack[#peek_stack + 1] = winid
  end)
end
-- }}}

-- https://github.com/kosayoda/nvim-lightbulb {{{
local LIGHTBULB_AUGROUP = Dotfiles.augroup("lightbulb")

function M.attach_lightbulb(client, bufnr)
  if client.supports_method("textDocument/codeAction") then
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        if vim.bo[bufnr].buftype ~= "" then
          return
        end

        if vim.b[bufnr].lightbulb_cancel then
          pcall(vim.b[bufnr].lightbulb_cancel)
          vim.b[bufnr].lightbulb_cancel = nil
        end

        local params = vim.lsp.util.make_range_params(0, "utf-8")
        params.context = {
          diagnostics = vim.lsp.diagnostic.from(
            vim.diagnostic.get(bufnr, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
          ),
        }

        vim.b[bufnr].lightbulb_cancel = vim.F.npcall(
          vim.lsp.buf_request_all,
          bufnr,
          "textDocument/codeAction",
          params,
          function(res)
            local NS = Dotfiles.ns("lightbulb")

            vim.api.nvim_buf_clear_namespace(bufnr, NS, 0, -1)

            local has_action = false
            for _, r in pairs(res) do
              if r.result and not vim.tbl_isempty(r.result) then
                has_action = true
                break
              end
            end

            if not has_action then
              return
            end

            vim.api.nvim_buf_set_extmark(bufnr, NS, params.range.start.line, params.range.start.character + 1, {
              strict = false,
              virt_text = { { "💡" } },
              virt_text_pos = "eol",
            })
          end
        )
      end,
      group = LIGHTBULB_AUGROUP,
    })
  end
end
-- }}}

-- https://github.com/p00f/clangd_extensions.nvim/blob/main/lua/clangd_extensions/ast.lua {{{
local AST_NS = Dotfiles.ns("clangd_ast")
local ast_node_pos = {}
local ast_detail_pos = {}

-- TODO: refactor
function M.clangd_ast()
  local function clear_highlight(source_buf)
    vim.api.nvim_buf_clear_namespace(source_buf, AST_NS, 0, -1)
  end

  local function update_highlight(source_buf, ast_buf)
    clear_highlight(source_buf)

    if vim.api.nvim_get_current_buf() ~= ast_buf then
      return
    end

    local curline = vim.fn.getcurpos()[2]
    local curline_ranges = ast_node_pos[source_buf][ast_buf][curline]
    if curline_ranges then
      vim.hl.range(source_buf, AST_NS, "Search", curline_ranges.start, curline_ranges["end"], {
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
    local conf = Dotfiles.ui.icons.ast
    if conf.kind_icons[kind] then
      return conf.kind_icons[kind] .. "  "
    elseif conf.role_icons[role] then
      return conf.role_icons[role] .. "  "
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
      ast_detail_pos[hl_bufs.ast_buf][#result] = {
        start = string.len(padding) + detpos.start,
        ["end"] = string.len(padding) + detpos["end"],
      }
    end

    if node.range then
      ast_node_pos[hl_bufs.source_buf][hl_bufs.ast_buf][#result] = {
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
    for linenum, range in pairs(ast_detail_pos[ast_buf]) do
      vim.hl.range(ast_buf, AST_NS, "Comment", { linenum - 1, range.start }, { linenum - 1, range["end"] }, {
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

    if not ast_node_pos[source_buf] then
      ast_node_pos[source_buf] = {}
    end

    ast_node_pos[source_buf][b.clangd_ast_buf] = {}
    ast_detail_pos[b.clangd_ast_buf] = {}

    local lines = walk_tree(node, {}, {}, "", { source_buf = source_buf, ast_buf = b.clangd_ast_buf })
    vim.bo.modifiable = true
    vim.api.nvim_buf_set_lines(b.clangd_ast_buf, 0, -1, true, lines)
    vim.bo.modifiable = false
    setup_hl_autocmd(source_buf, b.clangd_ast_buf)
    highlight_detail(b.clangd_ast_buf)
  end

  vim.lsp.buf_request(0, "textDocument/ast", {
    textDocument = { uri = vim.uri_from_bufnr(0) },
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = vim.api.nvim_buf_line_count(0), character = 0 },
    },
  }, handler)
end
-- }}}

return M
