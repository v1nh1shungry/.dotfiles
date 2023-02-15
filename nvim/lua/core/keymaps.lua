local map = require('utils.keymaps').map
local nnoremap = require('utils.keymaps').nnoremap
local inoremap = require('utils.keymaps').inoremap
local tnoremap = require('utils.keymaps').tnoremap
local cnoremap = require('utils.keymaps').cnoremap
local vnoremap = require('utils.keymaps').vnoremap

map('<Space>', '<Nop>')
vim.g.mapleader = ' '

nnoremap('q', ':q<CR>')
nnoremap('Q', ':qa!<CR>')
nnoremap('<C-q>', ':bd<CR>')

inoremap('<C-s>', '<Esc>:w<CR>')
vnoremap('<C-s>', '<Esc>:w<CR>')
nnoremap('<C-s>', ':w<CR>')

cnoremap('<C-h>', '<Left>')
cnoremap('<C-j>', '<Down>')
cnoremap('<C-k>', '<Up>')
cnoremap('<C-l>', '<Right>')

nnoremap('<M-H>', '<C-w>h')
nnoremap('<M-J>', '<C-w>j')
nnoremap('<M-K>', '<C-w>k')
nnoremap('<M-L>', '<C-w>l')
inoremap('<M-H>', '<Esc><C-w>h')
inoremap('<M-J>', '<Esc><C-w>j')
inoremap('<M-K>', '<Esc><C-w>k')
inoremap('<M-L>', '<Esc><C-w>l')
tnoremap('<M-H>', '<C-\\><C-n><C-w>h')
tnoremap('<M-J>', '<C-\\><C-n><C-w>j')
tnoremap('<M-K>', '<C-\\><C-n><C-w>k')
tnoremap('<M-L>', '<C-\\><C-n><C-w>l')
tnoremap('<M-q>', '<C-\\><C-n>')
tnoremap('<M-p>', '<C-\\><C-n>pa')

vnoremap('<', '<gv')
vnoremap('>', '>gv')

nnoremap('<Leader>q', function()
  local nr = vim.fn.winnr('$')
  vim.cmd 'cwindow'
  if nr == vim.fn.winnr('$') then
    vim.cmd 'cclose'
  end
end)
