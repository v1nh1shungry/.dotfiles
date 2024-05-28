-- NOTE: ABOUT SYNC WITHIN MULTIPLE NEOVIM INSTANCES
--       The most common scenario is that open the window, edit,
--       then quit. I'm not going to open a window here, hang on,
--       then go to another neovim instance to open anoter window
--       and edit there. So this is not really a collaborative editing
--       scenario. Thus, we simply load the newest todo-list everytime
--       we enter the window, and save the current todo-list only when
--       we close the window.

local map = require("utils.keymap")

local winnr, bufnr
local config = {
  storage = vim.fs.joinpath(vim.fn.stdpath("data"), ".dotfiles_todo.txt"),
  width = 30,
  height = 5,
}
local ns = vim.api.nvim_create_namespace("dotfiles_todo_ns")
local augroup = vim.api.nvim_create_augroup("dotfiles_todo_autocmd", {})

local todo = {}

local function load_todo()
  if vim.fn.filereadable(config.storage) == 1 then
    todo = vim.fn.readfile(config.storage)
  end
end

local function save_todo() vim.fn.writefile(todo, config.storage) end

local function clear_extmark() vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1) end

local function get_highlight(index)
  if index == 1 then
    return "DiagnosticError"
  elseif index < 5 then
    return "DiagnosticWarn"
  else
    return "DiagnosticInfo"
  end
end

local function render()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, todo)
  clear_extmark()
  if #todo == 0 then
    vim.api.nvim_buf_set_extmark(bufnr, ns, 0, 0, { virt_text = { { "✅ ", "" }, { "All clear!", "Comment" } } })
  else
    for i = 1, #todo do
      vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
        virt_text = { { "📋 ", "" } },
        virt_text_pos = "inline",
      })
      vim.highlight.range(bufnr, ns, get_highlight(i), { i - 1, 0 }, { i - 1, #todo[i] })
    end
  end
end

local function update()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  todo = {}
  for _, l in ipairs(lines) do
    l = vim.trim(l)
    if #l ~= 0 then
      todo[#todo + 1] = l
    end
  end
  render()
end

---@param enter boolean?
local function open_win(enter)
  load_todo()

  enter = enter == nil or enter

  if bufnr == nil or not vim.api.nvim_buf_is_valid(bufnr) then
    bufnr = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_create_autocmd("InsertEnter", {
      buffer = bufnr,
      callback = clear_extmark,
      group = augroup,
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = update,
      group = augroup,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = bufnr,
      callback = load_todo,
      group = augroup,
    })
    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = bufnr,
      callback = save_todo,
      group = augroup,
    })
  end

  if winnr == nil or not vim.api.nvim_win_is_valid(winnr) then
    winnr = vim.api.nvim_open_win(bufnr, enter, {
      relative = "editor",
      border = "rounded",
      title = " TODO ",
      title_pos = "center",
      style = "minimal",
      width = config.width,
      height = config.height,
      row = 1,
      col = vim.o.columns - config.width,
    })
  end

  if enter then
    vim.cmd(vim.api.nvim_win_get_number(winnr) .. " wincmd w")
  end

  render()
end

local function close_win()
  if winnr and vim.api.nvim_win_is_valid(winnr) then
    vim.api.nvim_win_close(winnr, false)
  end
end

vim.api.nvim_create_autocmd("User", {
  callback = function(args)
    open_win(false)
    map({ "t", open_win, desc = "Edit TODO", buffer = args.buf })
  end,
  group = augroup,
  pattern = "AlphaReady",
})
vim.api.nvim_create_autocmd("User", {
  callback = close_win,
  group = augroup,
  pattern = "AlphaClosed",
})

map({ "<Leader>to", open_win, desc = "Edit TODO" })
map({ "<Leader>tq", close_win, desc = "Close TODO" })
