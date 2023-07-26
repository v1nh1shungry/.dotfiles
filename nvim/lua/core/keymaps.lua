local map = require('utils.keymaps').map
local nmap = require('utils.keymaps').nmap
local nnoremap = require('utils.keymaps').nnoremap
local inoremap = require('utils.keymaps').inoremap
local tnoremap = require('utils.keymaps').tnoremap
local vnoremap = require('utils.keymaps').vnoremap
local xnoremap = require('utils.keymaps').xnoremap

map { '<Space>', '<Nop>' }
vim.g.mapleader = ' '

nnoremap { 'q', ':q<CR>' }
nnoremap { 'Q', ':qa!<CR>' }
nnoremap { '<C-q>', ':bd<CR>' }

inoremap { '<C-s>', '<Esc>:w<CR>' }
vnoremap { '<C-s>', '<Esc>:w<CR>' }
nnoremap { '<C-s>', ':w<CR>' }

nnoremap { '<C-h>', '<C-w>h' }
nnoremap { '<C-j>', '<C-w>j' }
nnoremap { '<C-k>', '<C-w>k' }
nnoremap { '<C-l>', '<C-w>l' }

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

inoremap { ',', ',<c-g>u' }
inoremap { '.', '.<c-g>u' }
inoremap { ';', ';<c-g>u' }

nmap { 'j', "v:count == 0 ? 'gj' : 'j'", expr = true }
nmap { 'k', "v:count == 0 ? 'gk' : 'k'", expr = true }

nmap { 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', expr = true, desc = 'Visually select changed text' }

nnoremap { '[<Tab>', '<Cmd>tabprevious<CR>', desc = 'Previous tab' }
nnoremap { ']<Tab>', '<Cmd>tabnext<CR>', desc = 'Next tab' }

nnoremap { '<Leader><Tab>q', '<Cmd>tabclose<CR>', desc = 'Close tab' }

nnoremap { '<Leader>`', '<Cmd>e #<CR>', desc = 'Last buffer' }

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
nnoremap {
  '<Leader>uc',
  function()
    if vim.opt_local['conceallevel']:get() == 0 then
      vim.opt_local['conceallevel'] = conceallevel
    else
      vim.opt_local['conceallevel'] = 0
    end
  end,
  desc = 'Toggle conceal',
}
nnoremap { '<Leader>uw', '<Cmd>set wrap!<CR>', desc = 'Toggle wrap' }

nnoremap { '<Leader>fp', '<Cmd>e ~/.nvimrc<CR>', desc = 'Open preferences' }

nnoremap { '<M-j>', '<Cmd>m .+1<CR>==' }
nnoremap { '<M-k>', '<Cmd>m .-2<CR>==' }
inoremap { '<M-j>', '<Esc><Cmd>m .+1<CR>==gi' }
inoremap { '<M-k>', '<Esc><Cmd>m .-2<CR>==gi' }
vnoremap { '<M-j>', ":m '>+1<CR>gv=gv" }
vnoremap { '<M-k>', ":m '<-2<CR>gv=gv" }

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
