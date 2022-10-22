local status_mason_ok, mason = pcall(require, 'mason')
if not status_mason_ok then
  return
end

local status_ml_ok, ml = pcall(require, 'mason-lspconfig')
if not status_ml_ok then
  return
end

local status_lsp_ok, lspconfig = pcall(require, 'lspconfig')
if not status_lsp_ok then
  return
end

local handlers = require('plugins.lsp.handlers')

local servers = {
  'bashls',
  'clangd',
  'cmake',
  'cssls',
  'grammarly',
  'html',
  'jsonls',
  'tsserver',
  'sumneko_lua',
  'pyright',
  'rust_analyzer',
  'taplo',
  'vimls',
  'yamlls',
  'zls',
}

mason.setup()
ml.setup {
  ensure_installed = servers,
}
handlers.setup()

for _, server in ipairs(servers) do
  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
  }

  local status_setting_ok, setting = pcall(require, 'plugins.lsp.settings.' .. server)
  if status_setting_ok then
    opts = vim.tbl_deep_extend('force', setting, opts)
  end

  lspconfig[server].setup(opts)
end

require 'plugins.lsp.diagnostic'
require 'plugins.lsp.lspsaga'
