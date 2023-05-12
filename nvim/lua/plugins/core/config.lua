local M = {}

M.treesitter = function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bash',
      'c',
      'cmake',
      'cpp',
      'fish',
      'go',
      'javascript',
      'json',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'rust',
      'toml',
      'typescript',
      'vimdoc',
      'yaml',
    },
    highlight = { enable = true, additional_vim_regex_highlighting = true },
    matchup = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['ic'] = '@class.inner',
          ['ac'] = '@class.outer',
          ['if'] = '@function.inner',
          ['af'] = '@function.outer',
          ['ia'] = '@parameter.inner',
          ['aa'] = '@parameter.outer',
          ['as'] = '@statement.outer',
          ['al'] = '@assignment.lhs',
          ['ar'] = '@assignment.rhs',
        },
      },
      swap = {
        enable = true,
        swap_next = { [']a'] = '@parameter.inner' },
        swap_previous = { ['[a'] = '@parameter.inner' },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next = {
          [']f'] = '@function.outer',
          [']c'] = '@class.outer',
        },
        goto_previous = {
          ['[f'] = '@function.outer',
          ['[c'] = '@class.outer',
        },
      },
    },
    endwise = { enable = true },
  }
end

M.visual_multi = function()
  vim.g.VM_silent_exit = true
  vim.g.VM_set_statusline = 0
end

M.surround = function()
  require('mini.surround').setup {
    mappings = {
      add = 'ys',
      delete = 'ds',
      find = '',
      find_left = '',
      highlight = '',
      replace = 'cs',
      update_n_lines = '',
      suffix_last = '',
      suffix_next = '',
    },
    search_method = 'cover_or_next',
  }
  vim.keymap.del('x', 'ys')
  require('utils.keymaps').xmap('S', [[:<C-u>lua MiniSurround.add('visual')<CR>]])
  require('utils.keymaps').nmap('yss', 'ys_', { remap = true })
end

M.bracketed = function()
  local nnoremap = require('utils.keymaps').nnoremap
  require('mini.bracketed').setup {
    comment = { suffix = '' },
    diagnostic = { suffix = '' },
    file = { suffix = '' },
  }
  nnoremap('[<Space>', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = 'Put empty line above' })
  nnoremap(']<Space>', "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", { desc = 'Put empty line below' })
  nnoremap('[e', '<Cmd>m .-2<CR>==', { desc = 'Exchange with previous line' })
  nnoremap(']e', '<Cmd>m .+1<CR>==', { desc = 'Exchange with next line' })
end

return M
