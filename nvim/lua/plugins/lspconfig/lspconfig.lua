local lspconfig = require('lspconfig')
local signature = require('lsp_signature')
local format = require('lsp-format')

local setup_keymaps = function(bufnr)
  local keymap = function(modes, from, to)
    vim.keymap.set(modes, from, to, { noremap = true, silent = true, buffer = bufnr })
  end

  keymap('n', '<Leader>f', function() vim.lsp.buf.format { async = true } end)
  keymap('n', 'gh', '<Cmd>Lspsaga hover_doc<CR>')
  keymap({ 'n', 'v' }, '<Leader>ca', '<Cmd>Lspsaga code_action<CR>')
  keymap('n', '<Leader>rn', 'Lspsaga rename')
  keymap('n', 'gd', '<Cmd>TroubleToggle lsp_definitions<CR>')
  keymap('n', 'gr', '<Cmd>TroubleToggle lsp_references<CR>')
  keymap('n', '<Leader>o', '<Cmd>LSoutlineToggle<CR>')
  keymap('n', ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>')
  keymap('n', '[d', 'Lspsaga diagnostic_jump_prev<CR>')
end

local on_attach = function(client, bufnr)
  setup_keymaps(bufnr)

  local status_illuminate_ok, illuminate = pcall(require, 'illuminate')
  if status_illuminate_ok then
    illuminate.on_attach(client)
  end

  signature.on_attach {
    hi_parameter = 'Search',
    hint_prefix = '🤗'
  }

  format.on_attach(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local status_notify_ok, _ = pcall(require, 'notify')
if status_notify_ok then
  local notify = require('utils.notify')
  vim.lsp.handlers['$/progress'] = function(_, result, ctx)
    local client_id = ctx.client_id
    local val = result.value
    if not val.kind then
      return
    end
    local notif_data = notify.get_notif_data(client_id, result.token)
    if val.kind == 'begin' then
      local message = notify.format_message(val.message, val.percentage)
      notif_data.notification = vim.notify(message, 'info', {
        title = notify.format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
        icon = notify.spinner_frames[1],
        timeout = false,
        hide_from_history = false,
      })
      notif_data.spinner = 1
      notify.update_spinner(client_id, result.token)
    elseif val.kind == 'report' and notif_data then
      notif_data.notification = vim.notify(notify.format_message(val.message, val.percentage), 'info', {
        replace = notif_data.notification,
        hide_from_history = false,
      })
    elseif val.kind == 'end' and notif_data then
      notif_data.notification =
      vim.notify(val.message and notify.format_message(val.message) or 'Complete', 'info', {
        icon = '',
        replace = notif_data.notification,
        timeout = 3000,
      })
      notif_data.spinner = nil
    end
  end
  vim.lsp.handlers['window/showMessage'] = function(_, method, params, _)
    local severity = {
      'error',
      'warn',
      'info',
      'info',
    }
    vim.notify(method.message, severity[params.type])
  end
end

for _, server in ipairs(require('utils.lsp').servers) do
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  local status_setting_ok, setting = pcall(require, 'plugins.lspconfig.settings.' .. server)
  if status_setting_ok then
    opts = vim.tbl_deep_extend('force', setting, opts)
  end

  if server == 'rust_analyzer' then
    local status_rt_ok, rt = pcall(require, 'rust-tools')
    if status_rt_ok then
      rt.setup {
        server = opts,
      }
    else
      lspconfig.rust_analyzer.setup(opts)
    end
  elseif server == 'clangd' then
    local status_ce_ok, ce = pcall(require, 'clangd_extensions')
    if status_ce_ok then
      ce.setup {
        server = opts,
      }
    else
      lspconfig.clangd.setup(opts)
    end
  elseif server == 'sumneko_lua' then
    local status_neodev_ok, neodev = pcall(require, 'neodev')
    if status_neodev_ok then
      neodev.setup()
    end
    lspconfig.sumneko_lua.setup(opts)
  else
    lspconfig[server].setup(opts)
  end
end
