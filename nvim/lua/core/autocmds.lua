local autocmd = vim.api.nvim_create_autocmd

autocmd('FileType', {
  callback = function()
    local bufnr = tonumber(vim.fn.expand('<abuf>'))
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'j', 'gj', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'k', 'gk', { noremap = true, silent = true })
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
