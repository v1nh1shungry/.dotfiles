local map = require('utils.keymaps').map
local nmap = require('utils.keymaps').nmap
local cnoremap = require('utils.keymaps').cnoremap
local nnoremap = require('utils.keymaps').nnoremap
local inoremap = require('utils.keymaps').inoremap
local tnoremap = require('utils.keymaps').tnoremap
local vnoremap = require('utils.keymaps').vnoremap
local xnoremap = require('utils.keymaps').xnoremap

map { '<Space>', '<Nop>' }
vim.g.mapleader = ' '

nnoremap { '<Leader>qq', '<Cmd>qa!<CR>', desc = 'Quit' }

inoremap { '<C-s>', '<Esc>:w<CR>', desc = 'Save' }
nnoremap { '<C-s>', ':w<CR>', desc = 'Save' }

tnoremap { '<Esc><Esc>', '<C-\\><C-n>' }

vnoremap { '<', '<gv' }
vnoremap { '>', '>gv' }

nnoremap {
  '<Leader>xq',
  function()
    local nr = vim.fn.winnr('$')
    vim.cmd('cwindow')
    if nr == vim.fn.winnr('$') then
      vim.cmd('cclose')
    end
  end,
  desc = 'Toggle quickfix',
}

nnoremap {
  '<Leader>xl',
  function()
    local nr = vim.fn.winnr('$')
    vim.cmd('lwindow')
    if nr == vim.fn.winnr('$') then
      vim.cmd('lclose')
    end
  end,
  desc = 'Toggle location list',
}

inoremap { ',', ',<c-g>u' }
inoremap { '.', '.<c-g>u' }
inoremap { ';', ';<c-g>u' }

nmap { 'j', "v:count == 0 ? 'gj' : 'j'", expr = true }
nmap { 'k', "v:count == 0 ? 'gk' : 'k'", expr = true }

nmap { 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', expr = true, desc = 'Visually select changed text' }

nnoremap { '<Leader><Tab>q', '<Cmd>tabclose<CR>', desc = 'Close tab' }
nnoremap { '<Leader><Tab><Tab>', '<Cmd>tabnew<CR>', desc = 'New tab' }
nnoremap { ']<Tab>', '<Cmd>tabnext<CR>', desc = 'Next tab' }
nnoremap { '[<Tab>', '<Cmd>tabprev<CR>', desc = 'Previous tab' }

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

nnoremap { '<C-j>', '<Cmd>m .+1<CR>==', desc = 'Move down' }
nnoremap { '<C-k>', '<Cmd>m .-2<CR>==', desc = 'Move up' }
vnoremap { '<C-j>', ":m '>+1<CR>gv=gv", desc = 'Move down' }
vnoremap { '<C-k>', ":m '<-2<CR>gv=gv", desc = 'Move up' }

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

nnoremap { '<Leader>ct', vim.treesitter.inspect_tree, desc = 'Treesitter Tree' }

cnoremap { '<C-n>', '<Down>', desc = 'Next command ih history' }
cnoremap { '<C-p>', '<Up>', desc = 'Previous command ih history' }

nnoremap {
  '<Leader>mp',
  function()
    if vim.fn.mkdir('cmake', 'p') == 0 then
      vim.notify("CPM.cmake: can't create 'cmake' directory", vim.log.levels.ERROR)
      return
    end
    vim.system({
      'wget',
      '-O',
      'cmake/CPM.cmake',
      'https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake',
    }, {}, function(out)
      if out.code == 0 then
        vim.notify('CPM.cmake: downloaded cmake/CPM.cmake successfully')
      else
        vim.notify('CPM.cmake: failed to download CPM.cmake', vim.log.levels.ERROR)
      end
    end)
  end,
  desc = 'Get CPM.cmake',
}

local selected_hl_ns = vim.api.nvim_create_namespace('dotfiles_selected_highlight')
xnoremap {
  '<Leader>uh',
  function()
    vim.cmd [[execute "normal! \<ESC>"]]
    vim.highlight.range(0, selected_hl_ns, 'IncSearch', "'<", "'>", {
      inclusive = true,
      regtype = vim.fn.visualmode(),
    })
  end,
  desc = 'Highlight selected text',
}
nnoremap {
  '<Leader>uh',
  function()
      vim.api.nvim_buf_clear_namespace(0, selected_hl_ns, 1, -1)
  end,
  desc = 'Clear all text highlight',
}
