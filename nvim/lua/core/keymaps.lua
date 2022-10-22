local nnoremap = require('utils.keymaps').nnoremap
local inoremap = require('utils.keymaps').inoremap
local tnoremap = require('utils.keymaps').tnoremap
local cnoremap = require('utils.keymaps').cnoremap
local vnoremap = require('utils.keymaps').vnoremap

require('utils.keymaps').map('<Space>', '<Nop>')
vim.g.mapleader = ' '

nnoremap('q', ':q<CR>')
nnoremap('Q', ':qa!<CR>')
nnoremap('<C-q>', ':bd<CR>')

inoremap('<C-s>', '<Esc>:w<CR>')
nnoremap('<C-s>', ':w<CR>')

inoremap('<C-a>', '<Home>')
inoremap('<C-e>', '<End>')
inoremap('<C-h>', '<Left>')
inoremap('<C-j>', '<Down>')
inoremap('<C-k>', '<Up>')
inoremap('<C-l>', '<Right>')
cnoremap('<C-a>', '<Home>')
cnoremap('<C-e>', '<End>')
cnoremap('<C-h>', '<Left>')
cnoremap('<C-j>', '<Down>')
cnoremap('<C-k>', '<Up>')
cnoremap('<C-l>', '<Right>')

nnoremap('<A-H>', '<C-w>h')
nnoremap('<A-J>', '<C-w>j')
nnoremap('<A-K>', '<C-w>k')
nnoremap('<A-L>', '<C-w>l')
inoremap('<A-H>', '<Esc><C-w>h')
inoremap('<A-J>', '<Esc><C-w>j')
inoremap('<A-K>', '<Esc><C-w>k')
inoremap('<A-L>', '<Esc><C-w>l')
tnoremap('<A-H>', '<C-\\><C-n><C-w>h')
tnoremap('<A-J>', '<C-\\><C-n><C-w>j')
tnoremap('<A-K>', '<C-\\><C-n><C-w>k')
tnoremap('<A-L>', '<C-\\><C-n><C-w>l')

tnoremap('<A-q>', '<C-\\><C-n>')

vnoremap('p', '"_dP')

vnoremap('<', '<gv')
vnoremap('>', '>gv')
