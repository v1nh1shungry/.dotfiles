return function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bash',
      'c',
      'cmake',
      'cpp',
      'css',
      'fish',
      'html',
      'javascript',
      'json',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'regex',
      'rust',
      'toml',
      'typescript',
      'vim',
      'yaml',
      'zig',
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    indent = { enable = true },
    autopairs = { enable = true },
    matchup = { enable = true },
    rainbow = { enable = true },
    autotag = { enable = true },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
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
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
          ['ai'] = '@conditional.outer',
          ['ii'] = '@conditional.inner',
          ['a/'] = '@comment.outer',
          ['as'] = '@statement.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<A-l>'] = '@parameter.inner',
        },
        swap_previous = {
          ['<A-h>'] = '@parameter.inner',
        },
      },
    }
  }
end
