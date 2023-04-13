local autocmd = vim.api.nvim_create_autocmd

autocmd('FileType', {
  callback = function(opt)
    vim.api.nvim_buf_set_keymap(opt.buf, 'n', 'j', 'gj', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(opt.buf, 'n', 'k', 'gk', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(opt.buf, 'n', 'gj', 'j', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(opt.buf, 'n', 'gk', 'k', { noremap = true, silent = true })
    vim.cmd.setlocal 'wrap conceallevel=3'
  end,
  pattern = 'markdown',
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
  pattern = 'qf',
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
