local augroup = function(name) return vim.api.nvim_create_augroup('dotfiles_' .. name, { clear = true }) end

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
  group = augroup('checktime'),
})

vim.api.nvim_create_autocmd('FileType', {
  command = 'setlocal wrap',
  group = augroup('set_wrap'),
  pattern = { 'gitcommit', 'markdown' },
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank { timeout = 500 } end,
  group = augroup('highlight_yank'),
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  callback = function()
    if vim.wo.number and vim.api.nvim_get_mode() ~= 'i' then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
      vim.cmd('redraw')
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.bo.buflisted = false
    vim.wo.foldenable = false
    vim.wo.cc = ''
  end,
  group = augroup('no_fancy_ui'),
  pattern = require('utils.ui').excluded_filetypes,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(event)
    local exclude = { 'gitcommit' }
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
  group = augroup('last_loc')
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
  group = augroup('auto_create_dir'),
})

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, 'auto-cursorline')
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, 'auto-cursorline')
    end
  end,
})
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, 'auto-cursorline', cl)
      vim.wo.cursorline = false
    end
  end,
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
  group = augroup('resize_splits'),
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function() vim.bo.commentstring = '// %s' end,
  group = augroup('cpp_commentstring'),
  pattern = { 'c', 'cpp' },
})
