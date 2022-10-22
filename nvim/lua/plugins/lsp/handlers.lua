local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function ()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

local setup_keymaps = function(bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

  keymap('n', '<Leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

  local status_lspsaga_ok, _ = pcall(require, 'lspsaga')
  if status_lspsaga_ok then
    keymap('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', bufopts)
    keymap({'n','v'}, '<Leader>ca', '<Cmd>Lspsaga code_action<CR>', bufopts)
    keymap('n', '<Leader>rn', '<Cmd>Lspsaga rename<CR>', bufopts)
    keymap("n", "<Leader>o", "<Cmd>LSoutlineToggle<CR>", bufopts)
  else
    keymap('n', 'K', vim.lsp.buf.hover, bufopts)
    keymap({'n','v'}, '<Leader>ca', vim.lsp.buf.code_action, bufopts)
    keymap('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
  end

  local status_trouble_ok, _ = pcall(require, 'trouble')
  if status_trouble_ok then
    keymap('n', 'gd', '<Cmd>TroubleToggle lsp_definitions<CR>', bufopts)
    keymap('n', 'gi', '<Cmd>TroubleToggle lsp_implementations<CR>', bufopts)
    keymap('n', 'gy', '<Cmd>TroubleToggle lsp_type_definitions<CR>', bufopts)
    keymap('n', 'gr', '<Cmd>TroubleToggle lsp_references<CR>', bufopts)
    keymap('n', '<Leader>dd', '<Cmd>TroubleToggle document_diagnostics<CR>')
    keymap('n', '<Leader>wd', '<Cmd>TroubleToggle workspace_diagnostics<CR>')
  else
    keymap('n', 'gd', vim.lsp.buf.definition, bufopts)
    keymap('n', 'gi', vim.lsp.buf.implementation, bufopts)
    keymap('n', 'gy', vim.lsp.buf.type_definition, bufopts)
    keymap('n', 'gr', vim.lsp.buf.references, bufopts)
  end
end

M.on_attach = function(client, bufnr)
  setup_keymaps(bufnr)

  local status_illuminate_ok, illuminate = pcall(require, "illuminate")
  if status_illuminate_ok then
    illuminate.on_attach(client)
  end

  local status_signature_ok, signature = pcall(require, 'lsp_signature')
  if status_signature_ok then
    signature.on_attach({
      hi_parameter = "Search",
      hint_prefix = '🤗'
    })
  end
end

return M
