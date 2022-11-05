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

  keymap('n', '<Leader>f', function() vim.lsp.buf.format { async = true } end)
  keymap('n', 'gh', '<Cmd>Lspsaga hover_doc<CR>')
  keymap({ 'n', 'v' }, '<Leader>ca', '<Cmd>Lspsaga code_action<CR>')
  keymap('n', '<Leader>rn', 'Lspsaga rename')
  keymap('n', 'gd', '<Cmd>TroubleToggle lsp_definitions<CR>')
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

for _, server in ipairs(require('utils.lsp').servers) do
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  local status_setting_ok, setting = pcall(require, 'plugins.lspconfig.settings.' .. server)
  if status_setting_ok then
    opts = vim.tbl_deep_extend('force', setting, opts)
  end

  if server == 'sumneko_lua' then
    require('neodev').setup()
    lspconfig.sumneko_lua.setup(opts)
  elseif server == 'clangd' then
    require('clangd_extensions').setup {
      server = opts,
      extensions = { autoSetHints = false },
    }
  else
    lspconfig[server].setup(opts)
  end
end
