local map = require('utils.keymaps').map
local nmap = require('utils.keymaps').nmap
local nnoremap = require('utils.keymaps').nnoremap
local inoremap = require('utils.keymaps').inoremap
local tnoremap = require('utils.keymaps').tnoremap
local vnoremap = require('utils.keymaps').vnoremap
local xnoremap = require('utils.keymaps').xnoremap

map { '<Space>', '<Nop>' }
vim.g.mapleader = ' '

nnoremap { 'q', ':q<CR>', desc = 'Quit' }
nnoremap { 'Q', ':qa!<CR>', desc = 'Force quit all' }
nnoremap { '<C-q>', ':bd<CR>', desc = 'Close buffer' }

inoremap { '<C-s>', '<Esc>:w<CR>', desc = 'Save' }
vnoremap { '<C-s>', '<Esc>:w<CR>', desc = 'Save' }
nnoremap { '<C-s>', ':w<CR>', desc = 'Save' }

nnoremap { '<C-h>', '<C-w>h', desc = 'Go to left window' }
nnoremap { '<C-j>', '<C-w>j', desc = 'Go to lower window' }
nnoremap { '<C-k>', '<C-w>k', desc = 'Go to upper window' }
nnoremap { '<C-l>', '<C-w>l', desc = 'Go to right window' }

tnoremap { '<Esc>', '<C-\\><C-n>' }

vnoremap { '<', '<gv' }
vnoremap { '>', '>gv' }

nnoremap { '<Leader>xq', function()
  local nr = vim.fn.winnr('$')
  vim.cmd 'cwindow'
  if nr == vim.fn.winnr('$') then
    vim.cmd 'cclose'
  end
end, desc = 'Toggle quickfix' }

nnoremap { '<Leader>xl', function()
  local nr = vim.fn.winnr('$')
  vim.cmd 'lwindow'
  if nr == vim.fn.winnr('$') then
    vim.cmd 'lclose'
  end
end, desc = 'Toggle location list' }

inoremap { ',', ',<c-g>u' }
inoremap { '.', '.<c-g>u' }
inoremap { ';', ';<c-g>u' }

nmap { 'j', "v:count == 0 ? 'gj' : 'j'", expr = true }
nmap { 'k', "v:count == 0 ? 'gk' : 'k'", expr = true }

nmap { 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', expr = true, desc = 'Visually select changed text' }

nnoremap { '<Leader><Tab>q', '<Cmd>tabclose<CR>', desc = 'Close tab' }
nnoremap { '<Leader><Tab><Tab>', '<Cmd>tabnew<CR>', desc = 'New tab' }

nnoremap { '<Leader>,', '<Cmd>e #<CR>', desc = 'Last buffer' }

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
nnoremap {
  '<Leader>uc',
  function()
    if vim.o.conceallevel == 0 then
      vim.o.conceallevel = conceallevel
    else
      vim.o.conceallevel = 0
    end
  end,
  desc = 'Toggle conceal',
}
nnoremap { '<Leader>uw', '<Cmd>set wrap!<CR>', desc = 'Toggle wrap' }

nnoremap { '<Leader>fc', '<Cmd>e ~/.nvimrc<CR>', desc = 'Open preferences' }

nnoremap { '<M-j>', '<Cmd>m .+1<CR>==', desc = 'Move down' }
nnoremap { '<M-k>', '<Cmd>m .-2<CR>==', desc = 'Move up' }
inoremap { '<M-j>', '<Esc><Cmd>m .+1<CR>==gi', desc = 'Move down' }
inoremap { '<M-k>', '<Esc><Cmd>m .-2<CR>==gi', desc = 'Move up' }
vnoremap { '<M-j>', ":m '>+1<CR>gv=gv", desc = 'Move down' }
vnoremap { '<M-k>', ":m '<-2<CR>gv=gv", desc = 'Move up' }

nnoremap {
  '[<Space>',
  "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  desc = 'Put empty line above',
}
nnoremap {
  ']<Space>',
  "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>",
  desc = 'Put empty line below',
}

nnoremap { '<Leader>l', '<Cmd>Lazy home<CR>', desc = 'Lazy' }

nnoremap { '<Leader>fu', '<Cmd>earlier 1f<CR>', desc = 'Give up modifications' }

xnoremap { '$', 'g_' }

nnoremap { '<Leader>ui', vim.show_pos, desc = 'Inspect pos' }

nnoremap { '<Leader>ct', vim.cmd.InspectTree, desc = 'Treesitter Tree' }
