local M = {}

local format = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local have_nls = package.loaded['null-ls']
      and (#require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') > 0)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      if have_nls then
        return client.name == 'null-ls'
      end
      return client.name ~= 'null-ls'
    end
  }
end

local on_attach = function(client, bufnr)
  local nnoremap = function(from, to, desc)
    local opts = { buffer = bufnr }
    if desc ~= nil then opts.desc = desc end
    require('utils.keymaps').nnoremap(from, to, opts)
  end
  local vnoremap = function(from, to)
    require('utils.keymaps').vnoremap(from, to, { buffer = bufnr })
  end

  nnoremap('=', format)
  vnoremap('=', format)
  nnoremap('gh', vim.lsp.buf.hover, 'Show hover document')
  nnoremap('<Leader>rn', '<Cmd>Lspsaga rename<CR>', 'Rename')
  nnoremap('<Leader>ca', '<Cmd>Lspsaga code_action<CR>')
  nnoremap('<Leader>o', '<Cmd>Lspsaga outline<CR>')
  nnoremap(']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>', 'Next diagnostic')
  nnoremap('[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', 'Previous diagnostic')
  nnoremap('gd', '<Cmd>Glance definitions<CR>', 'Go to definition')
  nnoremap('gy', '<Cmd>Glance type_definitions<CR>', 'Go to type definition')
  nnoremap('gR', '<Cmd>Glance references<CR>', 'Go to references')
  nnoremap('<Leader>lf', '<Cmd>Lspsaga lsp_finder<CR>', 'Lspsaga finder')
  nnoremap('<Leader>ss', '<Cmd>Telescope lsp_document_symbols<CR>', 'Browse LSP symbols')

  if client.supports_method('textDocument/formatting') and require('user').lsp.format_on_save then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = format,
    })
  end

  if client.supports_method('textDocument/codeLens') then
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = bufnr,
      command = 'lua vim.lsp.codelens.refresh()',
    })
  end
end

M.lspconfig = function()
  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  local servers = {
    'hls',
    'jsonls',
    'neocmake',
    'pylsp',
    'taplo',
  }

  require('mason-lspconfig').setup { automatic_installation = true }

  for _, server in ipairs(servers) do
    lspconfig[server].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      single_file_support = true,
    }
  end

  require('clangd_extensions').setup {
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = {
        'clangd',
        '--header-insertion=never',
        '--include-cleaner-stdlib',
        '--offset-encoding=utf-16', -- compatible with `null-ls`
      },
      filetypes = { 'c', 'cpp' },
    },
    extensions = {
      autoSetHints = false,
      ast = {
        role_icons = {
          type = '',
          declaration = '',
          expression = '',
          specifier = '',
          statement = '',
          ['template argument'] = '',
        },
        kind_icons = {
          Compound = '',
          Recovery = '',
          TranslationUnit = '',
          PackExpansion = '',
          TemplateTypeParm = '',
          TemplateTemplateParm = '',
          TemplateParamObject = '',
        },
      },
    },
  }

  require('neodev').setup()
  lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = require('plugins.ide.cmp.xmake.items') },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
        format = {
          defaultConfig = {
            trailing_table_separator = 'smart',
            align_call_args = true,
          },
        },
        hint = { enable = true },
      },
    },
  }

  lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ['rust-analyzer'] = {
        diagnostics = { disabled = { 'unresolved-proc-macro' } },
        cargo = { loadOutDirsFromCheck = true },
        procMacro = { enable = true },
        check = { command = 'clippy' },
      },
    },
  }

  lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  }

  lspconfig.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = { yaml = { keyOrdering = false } },
  }
end

M.null_ls = function()
  local actions = require('null-ls').builtins.code_actions
  local diagnostics = require('null-ls').builtins.diagnostics
  local formatting = require('null-ls').builtins.formatting

  require('null-ls').setup {
    sources = {
      actions.shellcheck,
      diagnostics.fish,
      diagnostics.shellcheck,
      formatting.fish_indent,
      formatting.just,
    },
    on_attach = on_attach,
  }

  require('mason-null-ls').setup { automatic_installation = true }
end

M.cmp = function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  require('plugins.ide.cmp')

  cmp.setup {
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    window = { completion = { side_padding = 0 } },
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        local kind = require('lspkind').cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          preset = 'codicons',
        })(entry, vim_item)
        local strings = vim.split(kind.kind, '%s', { trimempty = true })
        kind.kind = ' ' .. strings[1] .. ' '
        kind.menu = '    ' .. strings[2]
        return kind
      end
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<ESC>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm { select = true },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if not cmp.get_selected_entry() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            cmp.confirm()
          end
        elseif luasnip.expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
        else
          fallback()
        end
      end, { 'i', 's', 'c' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'xmake' },
    }, {
      { name = 'buffer' },
      { name = 'path' },
      { name = 'rg',    keyword_length = 5 },
    }, {
      { name = 'nvim_lsp_signature_help' },
    }),
  }

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources { { name = 'cmdline' }, { name = 'path' } },
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources { { name = 'buffer' } },
  })

  cmp.setup.filetype('markdown', { sources = cmp.config.sources { { name = 'emoji' } } })
end

M.dap = function()
  local dap, dapui = require('dap'), require('dapui')
  local icons = require('utils.ui').icons.dap

  vim.fn.sign_define(
    'DapBreakpoint',
    { text = icons.breakpoint, texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapBreakpointCondition',
    { text = icons.breakpoint_condition, texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapBreakpointRejected',
    { text = icons.breakpoint_rejected, texthl = 'DapBreakpoint', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapLogPoint',
    { text = icons.log_point, texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapStopped',
    { text = icons.stopped, texthl = 'DapStopped', linehl = '', numhl = '' }
  )

  dap.listeners.after.event_initialized['dapui_config'] = function()
    vim.diagnostic.config { virtual_text = false, signs = false }
    dapui.open()
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    vim.diagnostic.config { virtual_text = true, signs = true }
    dapui.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    vim.diagnostic.config { virtual_text = true, signs = true }
    dapui.close()
  end

  dapui.setup()

  local nnoremap = require('utils.keymaps').nnoremap
  nnoremap('<F10>', '<Cmd>DapStepOver<CR>')
  nnoremap('<F11>', '<Cmd>DapStepInto<CR>')
  nnoremap('<F12>', '<Cmd>DapStepOut<CR>')

  require('mason-nvim-dap').setup {
    ensure_installed = { 'codelldb' },
    handlers = {
      codelldb = function(config)
        config.configurations = require('plugins.ide.dap.standalone')
        require('mason-nvim-dap').default_setup(config)
      end
    }
  }
end

M.lspsaga = function()
  require('lspsaga').setup {
    code_action = {
      extend_gitsigns = false,
      show_server_name = true,
    },
    lightbulb = { sign = false },
    diagnostic = {
      on_insert = false,
      show_code_action = false,
    },
    symbol_in_winbar = { separator = ' > ' },
    ui = { winblend = require('user').ui.blend },
    beacon = { enable = false },
  }
end

M.gitsigns = function()
  local gitsigns = require('gitsigns')
  local nnoremap = require('utils.keymaps').nnoremap
  gitsigns.setup()
  nnoremap(']h', gitsigns.next_hunk, { desc = 'Next git hunk' })
  nnoremap('[h', gitsigns.prev_hunk, { desc = 'Previous git hunk' })
end

M.inlayhints = function()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      if args.data and args.data.client_id then
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require('lsp-inlayhints').on_attach(client, args.buf)
      end
    end,
  })
end

return M
