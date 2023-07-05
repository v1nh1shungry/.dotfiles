local M = {}

local on_attach = function(client, bufnr)
  local nnoremap = function(opts)
    opts.buffer = bufnr
    require('utils.keymaps').nnoremap(opts)
  end
  local vnoremap = function(opts)
    opts.buffer = bufnr
    require('utils.keymaps').vnoremap(opts)
  end
  local format = function() vim.lsp.buf.format { buffer = bufnr } end

  nnoremap { '<Leader>cf', format, desc = 'Format document' }
  vnoremap { '<Leader>cf', format, desc = 'Format range' }
  nnoremap { 'gh', vim.lsp.buf.hover, desc = 'Show hover document' }
  nnoremap { '<Leader>cr', '<Cmd>Lspsaga rename<CR>', desc = 'Rename' }
  nnoremap { '<Leader>ca', '<Cmd>Lspsaga code_action<CR>', desc = 'Code action' }
  nnoremap { '<Leader>uo', '<Cmd>Lspsaga outline<CR>', desc = 'Symbol outline' }
  nnoremap { '<Leader>cd', '<Cmd>Lspsaga show_line_diagnostics<CR>', desc = 'Show line diagnostics' }
  nnoremap { ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>', desc = 'Next diagnostic' }
  nnoremap { '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', desc = 'Previous diagnostic' }
  nnoremap {
    ']e',
    function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end,
    desc = 'Next error',
  }
  nnoremap {
    '[e',
    function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end,
    desc = 'Previous error',
  }
  nnoremap { 'gd', '<Cmd>Glance definitions<CR>', desc = 'Go to definition' }
  nnoremap { 'gy', '<Cmd>Glance type_definitions<CR>', desc = 'Go to type definition' }
  nnoremap { 'gR', '<Cmd>Glance references<CR>', desc = 'Go to references' }
  nnoremap { '<Leader>xl', '<Cmd>Lspsaga lsp_finder<CR>', desc = 'Lspsaga finder' }
  nnoremap { '<Leader>ss', '<Cmd>Telescope lsp_document_symbols<CR>', desc = 'Browse LSP symbols' }
  nnoremap { '<Leader>xx', '<Cmd>TroubleToggle<CR>', desc = 'Document diagnostics' }
end

M.lspconfig = function()
  local lspconfig = require('lspconfig')
  local servers = {
    'hls',
    'jsonls',
    'neocmake',
    'pylsp',
    'taplo',
  }

  require('mason-lspconfig').setup { automatic_installation = true }

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
    end
  })

  local register_capability = vim.lsp.handlers['client/registerCapability']

  vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
    local ret = register_capability(err, res, ctx)
    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local buffer = vim.api.nvim_get_current_buf()
    on_attach(client, buffer)
    return ret
  end

  local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
  )

  for _, server in ipairs(servers) do
    lspconfig[server].setup {
      capabilities = vim.deepcopy(capabilities),
      single_file_support = true,
    }
  end

  require('clangd_extensions').setup {
    server = {
      capabilities = vim.deepcopy(capabilities),
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
    capabilities = vim.deepcopy(capabilities),
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
    capabilities = vim.deepcopy(capabilities),
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
    capabilities = vim.deepcopy(capabilities),
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
    capabilities = vim.deepcopy(capabilities),
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
    vim.diagnostic.config { virtual_text = false }
    dapui.open()
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    vim.diagnostic.config { virtual_text = true }
    dapui.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    vim.diagnostic.config { virtual_text = true }
    dapui.close()
  end

  dapui.setup()

  local nnoremap = require('utils.keymaps').nnoremap
  nnoremap { '<Leader>dv', '<Cmd>DapStepOver<CR>', desc = 'Step over' }
  nnoremap { '<Leader>di', '<Cmd>DapStepInto<CR>', desc = 'Step into' }
  nnoremap { '<Leader>do', '<Cmd>DapStepOut<CR>', desc = 'Step out' }
  nnoremap { '<Leader>dt', function() dap.terminate() end, desc = 'Terminate' }


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
    code_action = { extend_gitsigns = false, show_server_name = true },
    lightbulb = { sign = false },
    ui = { winblend = require('user').ui.blend },
    beacon = { enable = false },
  }
end

M.gitsigns = function()
  local gitsigns = require('gitsigns')
  local nnoremap = require('utils.keymaps').nnoremap
  gitsigns.setup()
  nnoremap { ']h', gitsigns.next_hunk, desc = 'Next git hunk' }
  nnoremap { '[h', gitsigns.prev_hunk, desc = 'Previous git hunk' }
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

M.files = function()
  local show_hidden = false
  local filter_show = function(_) return true end
  local filter_hide = function(fs_entry)
    local should_hide = { '.cache', '.git', '.xmake', 'build', 'node_modules' }
    for _, fn in ipairs(should_hide) do
      if fs_entry.name == fn then return false end
    end
    return true
  end
  require('mini.files').setup { content = { filter = filter_hide } }
  local toggle_hidden = function()
    show_hidden = not show_hidden
    local new_filter = show_hidden and filter_show or filter_hide
    require('mini.files').refresh({ content = { filter = new_filter } })
  end
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      require('utils.keymaps').nnoremap {
        '.',
        toggle_hidden,
        buffer = args.data.buf_id,
        desc = 'Toggle show hidden files',
      }
    end,
  })
end

return M
