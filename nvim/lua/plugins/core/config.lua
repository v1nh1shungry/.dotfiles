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
      'help',
      'javascript',
      'json',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'rst',
      'rust',
      'toml',
      'vim',
      'yaml',
      'zig',
    },
    highlight = { enable = true, additional_vim_regex_highlighting = true },
    indent = { enable = true },
    matchup = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['a/'] = '@comment.outer',
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
    playground = { enable = true },
    query_linter = { enable = true },
    rainbow = { enable = true },
    endwise = { enable = true },
    incremental_selection = { enable = true },
  }
  vim.cmd [[
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
  set nofoldenable
  ]]
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

M.indent_blankline = {
  show_trailing_blankline_indent = false,
  show_current_context = true,
  show_current_context_start = true,
  use_treesitter = true,
}

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

return M
