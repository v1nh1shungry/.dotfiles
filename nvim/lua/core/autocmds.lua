local autocmd = vim.api.nvim_create_autocmd

autocmd('FileType', {
  callback = function() vim.cmd.setlocal 'wrap' end,
  pattern = { 'gitcommit', 'markdown' },
})

autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank { timeout = 500 } end,
  pattern = '*',
})

autocmd('InsertEnter', {
  callback = function()
    if vim.wo.number then vim.cmd.setlocal 'norelativenumber' end
  end,
})
autocmd('InsertLeave', {
  callback = function()
    if vim.wo.number then vim.cmd.setlocal 'relativenumber' end
  end,
})

autocmd('FileType', {
  command = 'setlocal nonumber norelativenumber',
  pattern = { 'qf', 'query' },
})

autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd({ 'BufWritePre' }, {
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

autocmd({ 'InsertLeave', 'WinEnter' }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, 'auto-cursorline')
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, 'auto-cursorline')
    end
  end,
})
autocmd({ 'InsertEnter', 'WinLeave' }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, 'auto-cursorline', cl)
      vim.wo.cursorline = false
    end
  end,
})
