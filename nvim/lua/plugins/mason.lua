return function()
  require('mason').setup()
  require('mason-lspconfig').setup {
    ensure_installed = {
      'bashls',
      'cmake',
      'grammarly',
      'jsonls',
      'marksman',
      'ocamllsp',
      'pyright',
      'rust_analyzer',
      'solargraph',
      'sumneko_lua',
      'taplo',
      'yamlls',
    },
  }
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
