local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

vim.diagnostic.config {
  signs = { active = signs },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
}

local lspconfig = require('lspconfig')

local setup_keymaps = function(bufnr)
  local keymap = function(modes, from, to)
    vim.keymap.set(modes, from, to, { noremap = true, silent = true, buffer = bufnr })
  end

  keymap('n', '=', function() vim.lsp.buf.format { async = true } end)
  keymap('n', 'gh', '<Cmd>Lspsaga hover_doc<CR>')
  keymap({ 'n', 'v' }, '<Leader>ca', '<Cmd>Lspsaga code_action<CR>')
  keymap('n', '<Leader>rn', '<Cmd>Lspsaga rename<CR>')
  keymap('n', 'gd', '<Cmd>TroubleToggle lsp_definitions<CR>')
  keymap('n', 'gy', '<Cmd>TroubleToggle lsp_type_definitions<CR>')
  keymap('n', 'gR', '<Cmd>TroubleToggle lsp_references<CR>')
  keymap('n', '<Leader>o', '<Cmd>LSoutlineToggle<CR>')
  keymap('n', ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>')
  keymap('n', '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>')
end

local on_attach = function(client, bufnr)
  setup_keymaps(bufnr)

  local status_illuminate_ok, illuminate = pcall(require, 'illuminate')
  if status_illuminate_ok then
    illuminate.on_attach(client)
  end

  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
    })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local servers = {
  'bashls',
  'cmake',
  'grammarly',
  'marksman',
  'pyright',
  'rust_analyzer',
  'taplo',
  'yamlls',
}

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

require('clangd_extensions').setup {
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
      'clangd',
      '--compile-commands-dir=build',
      '--all-scopes-completion',
      '--background-index',
      '--clang-tidy',
      '--completion-style=detailed',
      '--fallback-style=LLVM',
      '--function-arg-placeholders',
      '--header-insertion=never',
      '--include-cleaner-stdlib',
      '-j=12',
      '--pch-storage=memory',
      '--offset-encoding=utf-16', -- compatible with `null-ls`
    },
  },
  extensions = { autoSetHints = false },
}

lspconfig.jsonls.setup {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}

require('neodev').setup()
lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = { Lua = { telemetry = { enable = false } } },
}
