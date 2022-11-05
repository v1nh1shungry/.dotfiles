local nnoremap = require('utils.keymaps').nnoremap
local inoremap = require('utils.keymaps').inoremap
local tnoremap = require('utils.keymaps').tnoremap
local cnoremap = require('utils.keymaps').cnoremap
local vnoremap = require('utils.keymaps').vnoremap

--  ╭──────────────────────────────────────────────────────────╮
--  │                      Basic Keymaps                       │
--  ╰──────────────────────────────────────────────────────────╯
require('utils.keymaps').map('<Space>', '<Nop>')
vim.g.mapleader = ' '

nnoremap('q', ':q<CR>')
nnoremap('Q', ':qa!<CR>')
nnoremap('<C-w>', ':bd<CR>')

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

--  ╭──────────────────────────────────────────────────────────╮
--  │             Plugins' Keymaps (for lazy load)             │
--  ╰──────────────────────────────────────────────────────────╯

-- hop.nvim
nnoremap('gs', '<Cmd>HopChar1<CR>')
nnoremap('gw', '<Cmd>HopWord<CR>')
nnoremap('gl', '<Cmd>HopLine<CR>')
vnoremap('gs', '<Cmd>HopChar1<CR>')
vnoremap('gw', '<Cmd>HopWord<CR>')
vnoremap('gl', '<Cmd>HopLine<CR>')

-- neo-tree,nvim
nnoremap('<Leader>e', '<Cmd>NeoTreeFocusToggle<CR>')

-- nvim-telescope
nnoremap('<Leader>h', '<Cmd>Telescope help_tags<CR>')
nnoremap('<C-p>', '<Cmd>Telescope file_browser<CR>')

-- undotree
nnoremap('<Leader>u', '<Cmd>UndotreeToggle<CR>')

-- toggleterm.nvim
nnoremap('<M-=>', '<Cmd>ToggleTerm<CR>')
tnoremap('<M-=>', '<C-\\><C-n>:ToggleTerm<CR>')

-- asynctasks.vim
nnoremap('<Leader>fb', '<Cmd>AsyncTask file-build<CR>')
nnoremap('<Leader>fr', '<Cmd>AsyncTask file-run<CR>')

-- nvim-dap
nnoremap('<F9>', '<Cmd>DapToggleBreakpoint<CR>')
nnoremap('<F5>', '<Cmd>DapContinue<CR>')
