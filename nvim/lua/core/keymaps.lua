local map = require('utils.keymap')
local toggle = require('utils.toggle')

vim.g.mapleader = ' '

map({ '<Leader>qq', '<Cmd>qa!<CR>', desc = 'Quit' })

map({ '<C-s>', '<Cmd>w<CR><Esc>', desc = 'Save', mode = { 'i', 'x', 'n', 's' } })

map({ '<Esc><Esc>', '<C-\\><C-n>', mode = 't' })

map({ '<', '<gv', mode = 'v' })
map({ '>', '>gv', mode = 'v' })

map({ '<Leader>xq', toggle.quickfix, desc = 'Toggle quickfix' })

map({ '<Leader>xl', toggle.location, desc = 'Toggle location list' })

map({ ',', ',<c-g>u', mode = 'i' })
map({ '.', '.<c-g>u', mode = 'i' })
map({ ';', ';<c-g>u', mode = 'i' })

map({ 'j', "v:count == 0 ? 'gj' : 'j'", expr = true, desc = 'Down' })
map({ 'k', "v:count == 0 ? 'gk' : 'k'", expr = true, desc = 'Up' })

map({ 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', expr = true, desc = 'Visually select changed text' })

map({ '<Leader><Tab>q', '<Cmd>tabclose<CR>', desc = 'Close tab' })
map({ '<Leader><Tab><Tab>', '<Cmd>tabnew<CR>', desc = 'New tab' })
map({ ']<Tab>', '<Cmd>tabnext<CR>', desc = 'Next tab' })
map({ '[<Tab>', '<Cmd>tabprev<CR>', desc = 'Previous tab' })

map({ '<Leader>,', '<Cmd>e #<CR>', desc = 'Last buffer' })

map({
  '<Leader>uc',
  function()
    toggle.option('conceallevel', false, { 0, 3 })
  end,
  desc = 'Toggle conceal',
})
map({
  '<Leader>uw',
  function()
    toggle.option('wrap')
  end,
  desc = 'Toggle wrap',
})

map({ '<Leader>fc', '<Cmd>e ~/.nvimrc<CR>', desc = 'Open preferences' })

map({ '<C-j>', '<Cmd>m .+1<CR>==', desc = 'Move down' })
map({ '<C-k>', '<Cmd>m .-2<CR>==', desc = 'Move up' })
map({ '<C-j>', ":m '>+1<CR>gv=gv", mode = 'v', desc = 'Move down' })
map({ '<C-k>', ":m '<-2<CR>gv=gv", mode = 'v', desc = 'Move up' })

map({
  '[<Space>',
  "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  desc = 'Put empty line above',
})
map({
  ']<Space>',
  "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>",
  desc = 'Put empty line below',
})

map({ '<Leader>l', '<Cmd>Lazy home<CR>', desc = 'Lazy' })

map({ '<Leader>fu', '<Cmd>earlier 1f<CR>', desc = 'Give up modifications' })

map({ '$', 'g_', mode = 'x', desc = 'End of line' })

map({ '<Leader>ut', vim.treesitter.inspect_tree, desc = 'Treesitter Tree' })

map({ '<C-n>', '<Down>', desc = 'Next command ih history', mode = 'c' })
map({ '<C-p>', '<Up>', desc = 'Previous command ih history', mode = 'c' })

map({
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
})

local selected_hl_ns = vim.api.nvim_create_namespace('dotfiles_selected_highlight')
map({
  '<Leader>uh',
  function()
    vim.cmd([[execute "normal! \<ESC>"]])
    vim.highlight.range(0, selected_hl_ns, 'IncSearch', "'<", "'>", {
      inclusive = true,
      regtype = vim.fn.visualmode(),
    })
  end,
  desc = 'Highlight selected text',
  mode = 'x',
})
map({
  '<Leader>uh',
  function()
    vim.api.nvim_buf_clear_namespace(0, selected_hl_ns, 1, -1)
  end,
  desc = 'Clear all text highlight',
})
