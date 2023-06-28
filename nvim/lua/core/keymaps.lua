local map = require('utils.keymaps').map
local nmap = require('utils.keymaps').nmap
local nnoremap = require('utils.keymaps').nnoremap
local inoremap = require('utils.keymaps').inoremap
local tnoremap = require('utils.keymaps').tnoremap
local vnoremap = require('utils.keymaps').vnoremap

map('<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

nnoremap('q', ':q<CR>')
nnoremap('Q', ':qa!<CR>')
nnoremap('<C-q>', ':bd<CR>')

inoremap('<C-s>', '<Esc>:w<CR>')
vnoremap('<C-s>', '<Esc>:w<CR>')
nnoremap('<C-s>', ':w<CR>')

nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-k>', '<C-w>k')
nnoremap('<C-l>', '<C-w>l')
tnoremap('<C-h>', '<C-\\><C-n><C-w>h')
tnoremap('<C-j>', '<C-\\><C-n><C-w>j')
tnoremap('<C-k>', '<C-\\><C-n><C-w>k')
tnoremap('<C-l>', '<C-\\><C-n><C-w>l')
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
end, { desc = 'Toggle quickfix' })

inoremap(',', ',<c-g>u')
inoremap('.', '.<c-g>u')
inoremap(';', ';<c-g>u')

nmap('j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
nmap('k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

nmap('gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, desc = 'Visually select changed text' })

nnoremap('<Leader>\\', '<Cmd>vsplit<CR>', { desc = 'Vertical split' })
nnoremap('<Leader>-', '<Cmd>split<CR>', { desc = 'Split screen' })
