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
      'vim',
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
        swap_next = { ['<M-l>'] = '@parameter.inner' },
        swap_previous = { ['<M-h>'] = '@parameter.inner' },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next = {
          [']f'] = '@function.outer',
          [']s'] = '@class.outer',
        },
        goto_previous = {
          ['[f'] = '@function.outer',
          ['[s'] = '@class.outer',
        },
      },
    },
    rainbow = { enable = true },
  }
end

M.tabout = function()
  local _, _ = pcall(require, 'cmp') -- cmp use tab too, let it first if present
  require('tabout').setup {
    tabouts = {
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = '`', close = '`' },
      { open = '(', close = ')' },
      { open = '[', close = ']' },
      { open = '<', close = '>' },
      { open = '#', close = ']' },
    },
  }
end

M.hlslens = function()
  require('hlslens').setup { calm_down = true, nearest_only = true }
  vim.opt.shortmess:append 'S'
  vim.api.nvim_create_autocmd('User', {
    callback = require('hlslens').start,
    pattern = 'visual_multi_start',
  })
  vim.api.nvim_create_autocmd('User', {
    callback = require('hlslens').stop,
    pattern = 'visual_multi_exit',
  })
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

return M
