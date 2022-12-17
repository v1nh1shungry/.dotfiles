return function()
  local nnoremap = require('utils.keymaps').nnoremap

  vim.g.asyncrun_open = 10
  vim.g.asynctasks_term_rows = 10
  vim.g.asynctasks_term_pos = 'bottom'

  nnoremap('<Leader>fb', '<Cmd>AsyncTask file-build<CR>')
  nnoremap('<Leader>fr', '<Cmd>AsyncTask file-run<CR>')
end
