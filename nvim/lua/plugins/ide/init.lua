local events = require('utils.events')

local M = {
  {
    'neovim/nvim-lspconfig',
    config = function(_, lsp_opts)
      local on_attach = function(client, bufnr)
        local format = function() vim.lsp.buf.format { buffer = bufnr } end
        local map = function(opts)
          require('utils.keymaps').noremap(vim.tbl_extend('keep', opts, {
            buffer = bufnr,
            mode = 'n',
          }))
        end

        local mappings = {
          ['textDocument/formatting'] = {
            { '<Leader>cf', format, desc = 'Format document' },
          },
          ['textDocument/rangeFormatting'] = {
            { '<Leader>cf', format, desc = 'Format range', mode = 'v' },
            {
              '<Leader>gf',
              function()
                require('lsp-format-modifications').format_modifications(client, bufnr)
              end,
              desc = 'Format only modifications',
            },
          },
          ['textDocument/rename'] = {
            { '<Leader>cr', '<Cmd>Lspsaga rename<CR>', desc = 'Rename' },
          },
          ['textDocument/codeAction'] = {
            { '<Leader>ca', '<Cmd>Lspsaga code_action<CR>', desc = 'Code action' },
          },
          ['textDocument/documentSymbol'] = {
            { '<Leader>uo', '<Cmd>Lspsaga outline<CR>',                desc = 'Symbol outline' },
            { '<Leader>ss', '<Cmd>Telescope lsp_document_symbols<CR>', desc = 'Browse LSP symbols' },
          },
          ['textDocument/references'] = {
            { 'gR', '<Cmd>Glance references<CR>', desc = 'Go to references' },
          },
          ['textDocument/definition'] = {
            { 'gd',         '<Cmd>Glance definitions<CR>',      desc = 'Go to definition' },
            { '<Leader>cp', '<Cmd>Lspsaga peek_definition<CR>', desc = 'Preview definition' },
          },
          ['textDocument/typeDefinition*'] = {
            { 'gy', '<Cmd>Glance type_definitions<CR>', desc = 'Go to type definition' },
          },
          ['textDocument/implementation*'] = {
            { 'gi', '<Cmd>Glance implementations<CR>', desc = 'Go to implementation' },
          },
          ['callHierarchy/incomingCalls'] = {
            { '<Leader>ci', '<Cmd>Lspsaga incoming_calls<CR>', desc = 'Incoming calls' },
          },
          ['callHierarchy/outgoingCalls'] = {
            { '<Leader>co', '<Cmd>Lspsaga outgoing_calls<CR>', desc = 'Outgoing calls' },
          },
          ['textDocument/inlayHint'] = {
            { '<Leader>ui', function() vim.lsp.inlay_hint(bufnr) end, desc = 'Toggle inlay hint' },
          },
        }
        for _, key in ipairs({
          { '<Leader>cd', '<Cmd>Lspsaga show_line_diagnostics<CR>', desc = 'Show diagnostics' },
          { ']d',         '<Cmd>Lspsaga diagnostic_jump_next<CR>',  desc = 'Next diagnostic' },
          { '[d',         '<Cmd>Lspsaga diagnostic_jump_prev<CR>',  desc = 'Previous diagnostic' },
          {
            ']w',
            function()
              require('lspsaga.diagnostic'):goto_next { severity = vim.diagnostic.severity.WARN }
            end,
            desc = 'Next warning',
          },
          {
            '[w',
            function()
              require('lspsaga.diagnostic'):goto_prev { severity = vim.diagnostic.severity.WARN }
            end,
            desc = 'Previous warning',
          },
          {
            ']e',
            function()
              require('lspsaga.diagnostic'):goto_next { severity = vim.diagnostic.severity.ERROR }
            end,
            desc = 'Next error',
          },
          {
            '[e',
            function()
              require('lspsaga.diagnostic'):goto_prev { severity = vim.diagnostic.severity.ERROR }
            end,
            desc = 'Previous error',
          },
          { '<Leader>xx', '<Cmd>TroubleToggle document_diagnostics<CR>',  desc = 'Document diagnostics' },
          { '<Leader>xX', '<Cmd>TroubleToggle workspace_diagnostics<CR>', desc = 'Workspace Diagnostics' },
          { '<Leader>cn', '<Cmd>Lspsaga finder<CR>',                      desc = 'LSP nagivation pane' },
        }) do
          map(key)
        end
        for method, keys in pairs(mappings) do
          if client.supports_method(method) then
            for _, key in ipairs(keys) do
              map(key)
            end
          end
        end
        if lsp_opts.servers[client.name] and lsp_opts.servers[client.name].keys then
          for _, key in ipairs(lsp_opts.servers[client.name].keys) do
            map(key)
          end
        end

        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint(bufnr, true)
        end
      end

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

      for name, icon in pairs {
        DiagnosticSignError = '',
        DiagnosticSignWarn = '',
        DiagnosticSignHint = '',
        DiagnosticSignInfo = '',
      } do
        vim.fn.sign_define(name, { texthl = name, text = icon, numhl = '' })
      end

      vim.diagnostic.config(vim.deepcopy(lsp_opts.diagnostics))

      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(),
        {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        }
      )

      for server, opts in pairs(lsp_opts.servers) do
        opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
          single_file_support = true,
        }, opts)
        require('lspconfig')[server].setup(opts)
      end
    end,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      {
        'folke/neodev.nvim',
        config = true,
      },
      {
        'p00f/clangd_extensions.nvim',
        opts = {
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
      },
      'williamboman/mason-lspconfig.nvim',
      'joechrisellis/lsp-format-modifications.nvim',
      {
        'folke/neoconf.nvim',
        config = true,
      },
    },
    opts = {
      diagnostics = {
        virtual_text = { spacing = 4, source = 'if_many' },
        severity_sort = true,
        signs = false,
      },
      servers = {
        jsonls = {},
        neocmake = {},
        clangd = {
          cmd = {
            'clangd',
            '--compile-commands-dir=build',
            '--header-insertion=never',
            '--include-cleaner-stdlib',
          },
          filetypes = { 'c', 'cpp' },
          keys = {
            {
              '<Leader>ct',
              '<Cmd>ClangdAST<CR>',
              desc = 'Clangd AST',
              mode = { 'n', 'v' },
            },
            {
              '<Leader>cs',
              '<Cmd>ClangdSwitchSourceHeader<CR>',
              desc = 'Switch between source and header',
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              telemetry = { enable = false },
              workspace = { checkThirdParty = false },
              format = {
                defaultConfig = {
                  call_arg_parentheses = 'remove_table_only',
                  trailing_table_separator = 'smart',
                  align_call_args = true,
                },
              },
            },
          },
        },
      },
    },
  },
  {
    'glepnir/lspsaga.nvim',
    event = 'LspAttach',
    opts = {
      code_action = { extend_gitsigns = false, show_server_name = true },
      lightbulb = { sign = false },
      ui = { winblend = require('user').ui.blend },
      beacon = { enable = false },
    },
  },
  {
    'williamboman/mason.nvim',
    config = true,
    lazy = true,
    keys = { { '<Leader>cm', '<Cmd>Mason<CR>', desc = 'Mason' } },
  },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

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
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
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
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
          { name = 'rg',    keyword_length = 3 },
        }),
      }

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
          { name = 'cmdline' },
          { name = 'path' },
        },
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources { { name = 'buffer' } },
      })

      cmp.setup.filetype('markdown', {
        sources = cmp.config.sources {
          { name = 'buffer' },
          { name = 'path' },
          { name = 'rg',    keyword_length = 3 },
          { name = 'emoji' },
        },
      })
    end,
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      {
        'saadparwaiz1/cmp_luasnip',
        dependencies = {
          'L3MON4D3/LuaSnip',
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'onsails/lspkind.nvim',
      'lukas-reineke/cmp-rg',
      'hrsh7th/cmp-emoji',
    },
    event = events.enter_insert,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = events.enter_buffer,
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local map = function(opts)
          require('utils.keymaps').noremap(vim.tbl_extend('keep', opts, {
            buffer = buffer,
            mode = 'n',
          }))
        end
        map { '<Leader>gp', '<Cmd>Gitsigns preview_hunk<CR>', desc = 'Preview hunk' }
        map { '<Leader>gr', '<Cmd>Gitsigns reset_hunk<CR>', desc = 'Reset hunk' }
        map { '<Leader>gd', '<Cmd>Gitsigns diffthis<CR>', desc = 'Diff this' }
        map { '<Leader>gb', '<Cmd>Gitsigns blame_line<CR>', desc = 'Blame this line' }
        map { '<Leader>ub', '<Cmd>Gitsigns toggle_current_line_blame<CR>', desc = 'Toggle git blame' }
        map { ']h', function() gs.next_hunk { navigation_message = false } end, desc = 'Next git hunk' }
        map { '[h', function() gs.prev_hunk { navigation_message = false } end, desc = 'Previous git hunk' }
        map { '<Leader>gs', '<Cmd>Gitsigns stage_hunk<CR>', desc = 'Stage hunk' }
        map { '<Leader>gu', '<Cmd>Gitsigns undo_stage_hunk<R>', desc = 'Undo staged hunk' }
        map { 'ih', ':<C-U>Gitsigns select_hunk<CR>', mode = { 'o', 'x' }, desc = 'Git hunk' }
      end,
    },
  },
  {
    'akinsho/toggleterm.nvim',
    keys = { { '<M-=>', desc = 'Toggle terminal' } },
    opts = { open_mapping = '<M-=>', size = 10 },
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')

      vim.fn.sign_define(
        'DapBreakpoint',
        { text = '󰝥', texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapBreakpointCondition',
        { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapBreakpointRejected',
        { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapLogPoint',
        { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapStopped',
        { text = '󰁕', texthl = 'DapStopped', linehl = '', numhl = '' }
      )

      local nnoremap = require('utils.keymaps').nnoremap
      nnoremap { '<Leader>dv', '<Cmd>DapStepOver<CR>', desc = 'Step over' }
      nnoremap { '<Leader>di', '<Cmd>DapStepInto<CR>', desc = 'Step into' }
      nnoremap { '<Leader>do', '<Cmd>DapStepOut<CR>', desc = 'Step out' }
      nnoremap { '<Leader>dt', function() dap.terminate() end, desc = 'Terminate' }
    end,
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        config = function()
          local dap, dapui = require('dap'), require('dapui')
          dapui.setup()
          dap.listeners.after.event_initialized['dapui_config'] = function()
            vim.diagnostic.config { virtual_text = false }
            vim.lsp.inlay_hint(0, false)
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            vim.diagnostic.config { virtual_text = true }
            vim.lsp.inlay_hint(0, true)
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            vim.diagnostic.config { virtual_text = true }
            vim.lsp.inlay_hint(0, true)
            dapui.close()
          end
        end,
        keys = {
          { '<Leader>de', function() require('dapui').eval() end, desc = 'Eval', mode = { 'n', 'v' } },
        },
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        config = true,
      },
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = 'mason.nvim',
        opts = { ensure_installed = { 'codelldb' }, handlers = {} },
      },
      {
        'folke/which-key.nvim',
        optional = true,
        opts = { defaults = { ['<Leader>d'] = { name = '+debug' } } },
      },
    },
    keys = {
      { '<Leader>db', '<Cmd>DapToggleBreakpoint<CR>', desc = 'Toggle breakpoint' },
      { '<Leader>dc', '<Cmd>DapContinue<CR>',         desc = 'Continue' },
    },
  },
  {
    'folke/trouble.nvim',
    cmd = 'TroubleToggle',
    keys = {
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous trouble/quickfix item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    }
  },
  {
    'DNLHC/glance.nvim',
    cmd = 'Glance',
  },
}

for _, lang in ipairs(require('user').plugins.langs) do
  for _, spec in ipairs(require('plugins.ide.lang.' .. lang)) do
    M[#M + 1] = spec
  end
end

return M
