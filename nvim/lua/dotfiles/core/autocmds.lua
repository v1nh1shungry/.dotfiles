local augroup = function(name) return vim.api.nvim_create_augroup("dotfiles_" .. name, {}) end

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  group = augroup("checktime"),
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 500 }) end,
  group = augroup("highlight_yank"),
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.bo.buflisted = false
    vim.wo.foldenable = false
    vim.wo.cc = ""
    vim.wo.stc = ""
  end,
  group = augroup("minimal_ui"),
  pattern = require("dotfiles.utils.ui").excluded_filetypes,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(event)
    if vim.list_contains(require("dotfiles.utils.ui").excluded_buftypes, vim.bo.buftype) then
      local ret = vim.fn.maparg("q", "n", false, true)
      if ret.buffer ~= 1 then
        require("dotfiles.utils.keymap")({ "q", "<Cmd>close<CR>", desc = "Close", buffer = event.buf })
      end
    end
  end,
  group = augroup("close_with_q"),
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    local exclude = { "gitcommit", "man" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].dotfiles_last_loc then
      return
    end
    vim.b[buf].dotfiles_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  group = augroup("last_loc"),
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  group = augroup("auto_create_dir"),
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  group = augroup("resize_splits"),
})

vim.api.nvim_create_autocmd("BufNew", {
  callback = function()
    if vim.bo.buftype ~= "" then
      return
    end
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
      return
    end
    if vim.fn.filereadable(name) == 0 then
      return
    end
    for p in vim.fs.parents(name) do
      if p == vim.fn.getcwd() then
        return
      end
    end
    vim.bo.modifiable = false
  end,
  group = augroup("non_cwd_files_unmodifiable"),
})
