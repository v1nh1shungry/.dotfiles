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

tnoremap('<M-q>', '<C-\\><C-n>')

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

nnoremap('[<Tab>', '<Cmd>tabprevious<CR>', { desc = 'Previous tab' })
nnoremap(']<Tab>', '<Cmd>tabnext<CR>', { desc = 'Next tab' })
