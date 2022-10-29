return function()
  local nnoremap = require('utils.keymaps').nnoremap
  local vnoremap = require('utils.keymaps').vnoremap

  nnoremap(';', '<Plug>(clever-f-repeat-forward)')
  nnoremap(',', '<Plug>(clever-f-repeat-back)')
  vnoremap(';', '<Plug>(clever-f-repeat-forward)')
  vnoremap(',', '<Plug>(clever-f-repeat-back)')
end
