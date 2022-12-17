return function()
  vim.cmd [[packadd nvim-treesitter-textobjects]]
  vim.cmd [[packadd nvim-treesitter-context]]
  vim.cmd [[packadd playground]]

  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bash',
      'c',
      'cmake',
      'cpp',
      'css',
      'dockerfile',
      'fish',
      'go',
      'html',
      'java',
      'javascript',
      'json',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'ocaml',
      'ocaml_interface',
      'python',
      'query',
      'regex',
      'ruby',
      'rust',
      'scheme',
      'sql',
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
        },
      },
    },
    playground = { enable = true },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
  }
end
