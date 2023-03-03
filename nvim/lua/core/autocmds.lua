local autocmd = vim.api.nvim_create_autocmd

autocmd('FileType', {
  callback = function(opt)
    vim.api.nvim_buf_set_keymap(opt.buf, 'n', 'j', 'gj', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(opt.buf, 'n', 'k', 'gk', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(opt.buf, 'n', 'gj', 'j', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(opt.buf, 'n', 'gk', 'k', { noremap = true, silent = true })
    vim.cmd.setlocal 'wrap'
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
