local status_ok, todo = pcall(require, 'todo-comments')
if not status_ok then
  return
end

local nnoremap = require('utils.keymaps').nnoremap

todo.setup()

nnoremap('[t', function() todo.jump_prev() end)
nnoremap(']t', function() todo.jump_next() end)
