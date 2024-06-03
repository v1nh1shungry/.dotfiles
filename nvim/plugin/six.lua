local map = require("hero.utils.keymap")
local close = function(bufnr) require("mini.bufremove").delete(bufnr) end

local augroup = vim.api.nvim_create_augroup("hero_six_buffers_autocmds", {})

local threshold = 6

local function is_pinned(bufnr) return vim.b[bufnr].pinned end

local function toggle_pin() vim.b.pinned = not vim.b.pinned end

local function should_close(bufnr)
  return not (
    bufnr == vim.api.nvim_get_current_buf()
    or vim.bo[bufnr].modified
    or is_pinned(bufnr)
    or #vim.fn.win_findbuf(bufnr) > 0
  )
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if not vim.bo.buflisted then
      return
    end
    local current_bufnr = vim.api.nvim_get_current_buf()
    local buffers = vim.tbl_filter(function(b) return vim.bo[b].buflisted end, vim.api.nvim_list_bufs())
    if #buffers <= threshold then
      return
    end
    table.sort(buffers, function(lhs, rhs)
      if lhs == current_bufnr or rhs == current_bufnr then
        return rhs == current_bufnr
      end
      if vim.bo[lhs].modified ~= vim.bo[rhs].modified then
        return vim.bo[rhs].modified
      end
      if is_pinned(lhs) ~= is_pinned(rhs) then
        return is_pinned(rhs)
      end
      local lhs_in_window = #(vim.fn.win_findbuf(lhs)) > 0
      local rhs_in_window = #(vim.fn.win_findbuf(rhs)) > 0
      if lhs_in_window ~= rhs_in_window then
        return rhs_in_window
      end
      local lhs_unnamed = vim.api.nvim_buf_get_name(lhs) == ""
      local rhs_unnamed = vim.api.nvim_buf_get_name(rhs) == ""
      if lhs_unnamed ~= rhs_in_window then
        return rhs_unnamed
      end
      return lhs < rhs
    end)

    for i = 1, #buffers - threshold do
      local bufnr = buffers[i]
      if should_close(bufnr) then
        close(bufnr)
      end
    end
  end,
  group = augroup,
})

map({ "<Leader>fp", toggle_pin, desc = "Pin" })
map({
  "<Leader>fd",
  function()
    local buffers = vim.tbl_filter(
      function(b) return vim.bo[b].buflisted and not is_pinned(b) end,
      vim.api.nvim_list_bufs()
    )
    for _, bufnr in ipairs(buffers) do
      close(bufnr)
    end
  end,
  desc = "Close all unpinned buffers",
})
