return function()
  vim.cmd [[let g:pencil#wrapModeDefault = 'soft']]
  vim.cmd [[autocmd FileType markdown call pencil#init()]]
end
