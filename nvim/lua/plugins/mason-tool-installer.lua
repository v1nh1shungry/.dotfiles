return function()
  require('mason-tool-installer').setup {
    ensure_installed = {
      'autopep8',
      'cmakelang',
      'pylint',
      'rubocop',
      'shellcheck',
      'shfmt',
    },
  }
end
