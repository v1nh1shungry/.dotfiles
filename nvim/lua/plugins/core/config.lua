local M = {}

M.treesitter = function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bash',
      'c',
      'cmake',
      'cpp',
      'fish',
      'haskell',
      'javascript',
      'json',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'query',
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
        swap_next = { ['<M-l>'] = '@parameter.inner' },
        swap_previous = { ['<M-h>'] = '@parameter.inner' },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']a'] = '@parameter.inner',
          [']f'] = '@function.outer',
          [']c'] = '@class.outer',
        },
        goto_next_end = {
          [']F'] = '@function.outer',
          [']C'] = '@class.outer',
        },
        goto_previous_start = {
          ['[a'] = '@parameter.inner',
          ['[f'] = '@function.outer',
          ['[c'] = '@class.outer',
        },
        goto_previous_end = {
          ['[F'] = '@function.outer',
          ['[C'] = '@class.outer',
        },
      },
    },
    endwise = { enable = true },
    rainbow = { enable = true },
  }
end

M.visual_multi = function()
  vim.g.VM_silent_exit = true
  vim.g.VM_set_statusline = 0
  vim.g.VM_quit_after_leaving_insert_mode = true
  vim.g.VM_show_warnings = 0
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
  require('utils.keymaps').xmap { 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]] }
  require('utils.keymaps').nmap { 'yss', 'ys_', remap = true }
end

return M
