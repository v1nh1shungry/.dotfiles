return function()
  require('mason-lspconfig').setup {
    ensure_installed = require('utils.lsp').servers,
  }
end
