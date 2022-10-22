local status_ok, hop = pcall(require, 'hop')
if not status_ok then
  return
end

local nnoremap = require('utils.keymaps').nnoremap
local vnoremap = require('utils.keymaps').vnoremap

hop.setup()

nnoremap('<Leader>s', ':HopChar1<CR>')
nnoremap('<Leader>w', ':HopWord<CR>')
nnoremap('<Leader>l', ':HopLine<CR>')
vnoremap('<Leader>s', ':HopChar1<CR>')
vnoremap('<Leader>w', ':HopWord<CR>')
vnoremap('<Leader>l', ':HopLine<CR>')
