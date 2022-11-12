local autocmd = vim.api.nvim_create_autocmd

autocmd('FileType', { pattern = { 'noice', 'qf', 'startuptime' }, command = 'setlocal nonumber norelativenumber' })
autocmd('FileType', { pattern = 'markdown', command = 'setlocal wrap' })
autocmd('FileType', { pattern = 'cpp', command = [[setlocal commentstring=//%s]] })

autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = 'xmake.lua',
  command = 'setlocal filetype=xmake commentstring=--\\ %s',
})
