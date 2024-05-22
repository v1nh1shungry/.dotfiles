local events = require('utils.events')
local map = require('utils.keymap')

return {
  {
    'neovim/nvim-lspconfig',
    config = function(_, lsp_opts)
      local on_attach = function(client, bufnr)
        local map_local = function(opts)
          opts.buffer = bufnr
          map(opts)
        end

        local mappings = {
          ['textDocument/rename'] = {
            { '<Leader>cr', '<Cmd>Lspsaga rename<CR>', desc = 'Rename' },
          },
          ['textDocument/codeAction'] = {
            { '<Leader>ca', '<Cmd>Lspsaga code_action<CR>', desc = 'Code action' },
          },
          ['textDocument/documentSymbol'] = {
            { '<Leader>uo', '<Cmd>Lspsaga outline<CR>', desc = 'Symbol outline' },
            { '<Leader>ss', '<Cmd>Telescope lsp_document_symbols<CR>', desc = 'Browse LSP symbols (Document)' },
            { '<Leader>sS', '<Cmd>Telescope lsp_workspace_symbols<CR>', desc = 'Browse LSP symbols (Workspace)' },
          },
          ['textDocument/references'] = {
            { 'gR', '<Cmd>Glance references<CR>', desc = 'Go to references' },
          },
          ['textDocument/definition'] = {
            { 'gd', '<Cmd>Glance definitions<CR>', desc = 'Go to definition' },
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
            { '<Leader>uh', require('utils.toggle').inlay_hint, desc = 'Toggle inlay hint' },
          },
          ['textDocument/signatureHelp'] = {
            { '<C-k>', vim.lsp.buf.signature_help, mode = 'i', desc = 'Signature Help' },
          },
          ['textDocument/codeLens'] = {
            { '<Leader>cl', vim.lsp.codelens.run, mode = { 'n', 'v' }, desc = 'Run codelens' },
          },
        }
        for method, keys in pairs(mappings) do
          if client.supports_method(method) then
            for _, key in ipairs(keys) do
              map_local(key)
            end
          end
        end
        if lsp_opts.servers[client.name] and lsp_opts.servers[client.name].keys then
          for _, key in ipairs(lsp_opts.servers[client.name].keys) do
            map_local(key)
          end
        end

        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true)
        end

        if client.supports_method('textDocument/codeLens') then
          vim.lsp.codelens.refresh({ bufnr = bufnr })
          vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            buffer = bufnr,
            callback = function()
              vim.lsp.codelens.refresh({ bufnr = bufnr })
            end,
          })
        end
      end

      require('mason-lspconfig').setup({ automatic_installation = true })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
        end,
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

      vim.diagnostic.config(vim.deepcopy(lsp_opts.diagnostics))

      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

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
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = 'williamboman/mason.nvim',
      },
      {
        'folke/neoconf.nvim',
        opts = {},
      },
    },
    opts = {
      diagnostics = {
        virtual_text = { spacing = 4, source = 'if_many' },
        severity_sort = true,
        signs = false,
        update_in_insert = true,
      },
      servers = {
        jsonls = {},
        neocmake = {},
        clangd = {
          cmd = {
            'clangd',
            '--header-insertion=never',
            '--include-cleaner-stdlib',
          },
          on_new_config = function(new_config, _)
            require('cmake-tools').clangd_on_new_config(new_config)
          end,
          keys = { { '<Leader>cs', '<Cmd>ClangdSwitchSourceHeader<CR>', desc = 'Switch between source and header' } },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace', autoRequire = false },
              telemetry = { enable = false },
              workspace = { checkThirdParty = false },
            },
          },
        },
      },
    },
  },
  {
    'nvimdev/lspsaga.nvim',
    cmd = 'Lspsaga',
    keys = {
      { '<Leader>cd', '<Cmd>Lspsaga show_line_diagnostics<CR>', desc = 'Show diagnostics' },
      { ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>', desc = 'Next diagnostic' },
      { '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', desc = 'Previous diagnostic' },
      {
        ']w',
        function()
          require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.WARN })
        end,
        desc = 'Next warning',
      },
      {
        '[w',
        function()
          require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.WARN })
        end,
        desc = 'Previous warning',
      },
      {
        ']e',
        function()
          require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = 'Next error',
      },
      {
        '[e',
        function()
          require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = 'Previous error',
      },
      { '<Leader>cn', '<Cmd>Lspsaga finder<CR>', desc = 'LSP nagivation pane' },
    },
    opts = {
      code_action = { extend_gitsigns = false, show_server_name = true },
      lightbulb = { sign = false },
      ui = { winblend = require('user').ui.blend },
      beacon = { enable = false },
      symbol_in_winbar = { enable = false },
    },
  },
  {
    'williamboman/mason.nvim',
    keys = { { '<Leader>cm', '<Cmd>Mason<CR>', desc = 'Mason' } },
    opts = { ensure_installed = { 'stylua', 'gersemi' } },
  },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      for _, ft in ipairs({ 'cpp' }) do
        luasnip.add_snippets(ft, require('plugins.ide.snippets.' .. ft))
      end

      cmp.setup({
        window = { completion = { side_padding = 0 } },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(_, item)
            item.abbr = vim.trim(item.abbr)
            if #item.abbr > 50 then
              item.abbr = item.abbr:sub(1, 50) .. '…'
            end
            item.menu = item.kind
            item.kind = ' ' .. require('utils.ui').icons.lspkind[item.kind] .. ' '
            return item
          end,
          expandable_indicator = true,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if not cmp.get_selected_entry() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.confirm()
              end
            elseif luasnip.expand_or_locally_jumpable(1) then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
          { name = 'rg', keyword_length = 3 },
        }),
      })

      local cmdline_mapping = cmp.mapping.preset.cmdline({
        ['<C-n>'] = cmp.config.disable,
        ['<C-p>'] = cmp.config.disable,
      })

      cmp.setup.cmdline(':', {
        mapping = cmdline_mapping,
        sources = cmp.config.sources({
          { name = 'cmdline' },
          { name = 'path' },
        }),
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmdline_mapping,
        sources = cmp.config.sources({ { name = 'buffer' } }),
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
          build = 'make install_jsregexp',
          opts = { enable_autosnippets = true },
        },
      },
      'lukas-reineke/cmp-rg',
    },
    event = events.enter_insert,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = events.enter_buffer,
    opts = {
      on_attach = function(buffer)
        local map_local = function(opts)
          opts.buffer = buffer
          map(opts)
        end
        map_local({ '<Leader>gp', '<Cmd>Gitsigns preview_hunk<CR>', desc = 'Preview hunk' })
        map_local({ '<Leader>gr', '<Cmd>Gitsigns reset_hunk<CR>', desc = 'Reset hunk' })
        map_local({ '<Leader>gb', '<Cmd>Gitsigns blame_line<CR>', desc = 'Blame this line' })
        map_local({ '<Leader>ub', '<Cmd>Gitsigns toggle_current_line_blame<CR>', desc = 'Toggle git blame' })
        map_local({
          ']h',
          function()
            require('gitsigns').nav_hunk('next', { navigation_message = false })
          end,
          desc = 'Next git hunk',
        })
        map_local({
          '[h',
          function()
            require('gitsigns').nav_hunk('prev', { navigation_message = false })
          end,
          desc = 'Previous git hunk',
        })
        map_local({
          ']H',
          function()
            require('gitsigns').nav_hunk('last', { navigation_message = false })
          end,
          desc = 'Last git hunk',
        })
        map_local({
          '[H',
          function()
            require('gitsigns').nav_hunk('first', { navigation_message = false })
          end,
          desc = 'First git hunk',
        })
        map_local({ 'ih', ':<C-U>Gitsigns select_hunk<CR>', mode = { 'o', 'x' }, desc = 'Git hunk' })
      end,
    },
  },
  {
    'akinsho/toggleterm.nvim',
    cmd = 'TermExec',
    keys = { { '<M-=>', desc = 'Toggle terminal' } },
    opts = {
      open_mapping = '<M-=>',
      size = 10,
      float_opts = { title_pos = 'center', border = 'curved' },
    },
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      map({ '<Leader>dv', '<Cmd>DapStepOver<CR>', desc = 'Step over' })
      map({ '<Leader>di', '<Cmd>DapStepInto<CR>', desc = 'Step into' })
      map({ '<Leader>do', '<Cmd>DapStepOut<CR>', desc = 'Step out' })
      map({
        '<Leader>dt',
        function()
          require('dap').terminate()
        end,
        desc = 'Terminate',
      })
    end,
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        config = function()
          local dap, dapui = require('dap'), require('dapui')
          dapui.setup()
          dap.listeners.after.event_initialized['dapui_config'] = function()
            vim.diagnostic.hide()
            vim.lsp.inlay_hint.enable(false)
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            vim.diagnostic.show()
            vim.lsp.inlay_hint.enable(true)
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            vim.diagnostic.show()
            vim.lsp.inlay_hint.enable(true)
            dapui.close()
          end
          map({
            '<Leader>de',
            function()
              require('dapui').eval()
            end,
            desc = 'Eval',
            mode = { 'n', 'v' },
          })
        end,
        dependencies = 'nvim-neotest/nvim-nio',
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = 'williamboman/mason.nvim',
        opts = { automatic_installation = true, handlers = {} },
      },
      {
        'folke/which-key.nvim',
        optional = true,
        opts = { defaults = { ['<Leader>d'] = { name = '+debug' } } },
      },
      {
        'jbyuki/one-small-step-for-vimkind',
        config = function()
          local dap = require('dap')
          dap.adapters.nlua = function(callback, config)
            callback({
              type = 'server',
              host = config.host or '127.0.0.1',
              port = config.port or 8086,
            })
          end
          dap.configurations.lua = {
            {
              type = 'nlua',
              request = 'attach',
              name = 'Attach to running Neovim instance (port = 8086)',
              port = 8086,
            },
          }
        end,
        keys = {
          {
            '<Leader>dl',
            function()
              require('osv').launch({ port = 8086 })
            end,
            desc = 'Launch DAP server',
          },
        },
      },
    },
    keys = {
      { '<Leader>db', '<Cmd>DapToggleBreakpoint<CR>', desc = 'Toggle breakpoint' },
      { '<Leader>dc', '<Cmd>DapContinue<CR>', desc = 'Continue' },
    },
  },
  {
    'folke/trouble.nvim',
    cmd = 'TroubleToggle',
    keys = {
      { '<Leader>xx', '<Cmd>TroubleToggle document_diagnostics<CR>', desc = 'Document diagnostics' },
      { '<Leader>xX', '<Cmd>TroubleToggle workspace_diagnostics<CR>', desc = 'Workspace Diagnostics' },
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
        desc = 'Next trouble/quickfix item',
      },
    },
  },
  {
    'DNLHC/glance.nvim',
    cmd = 'Glance',
    opts = {
      hooks = {
        before_open = function(results, open, jump, _)
          if #results == 1 then
            jump(results[1])
          else
            open(results)
          end
        end,
      },
    },
  },
  {
    'stevearc/conform.nvim',
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = {
      {
        '<Leader>cf',
        function()
          require('conform').format({ lsp_fallback = true, quiet = true })
        end,
        desc = 'Format document',
        mode = { 'n', 'v' },
      },
    },
    opts = {
      formatters_by_ft = {
        fish = { 'fish_indent' },
        lua = { 'stylua' },
      },
    },
  },
  {
    'Bekaboo/dropbar.nvim',
    event = events.enter_buffer,
    keys = {
      {
        '<Leader>ud',
        function()
          require('dropbar.api').pick()
        end,
        desc = 'Dropbar',
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = events.enter_buffer,
    opts = {
      events = { 'BufWritePost', 'BufReadPost' },
      linters_by_ft = {
        c = { 'cppcheck' },
        cpp = { 'cppcheck' },
        fish = { 'fish' },
      },
      linters = {
        cppcheck = {
          args = {
            '--enable=style,performance,warning,portability',
            function()
              if vim.bo.filetype == 'cpp' then
                return '--language=c++'
              else
                return '--language=c'
              end
            end,
            '--inline-suppr',
            '--quiet',
            function()
              if vim.fn.isdirectory('build') == 1 then
                return '--cppcheck-build-dir=build'
              else
                return nil
              end
            end,
            '--template={file}:{line}:{column}: [{id}] {severity}: {message}',
          },
        },
      },
    },
    config = function(_, opts)
      local M = {}

      local lint = require('lint')
      for name, linter in pairs(opts.linters) do
        if type(linter) == 'table' and type(lint.linters[name]) == 'table' then
          lint.linters[name] = vim.tbl_deep_extend('force', lint.linters[name], linter)
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)
        names = vim.list_extend({}, names)
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft['_'] or {})
        end
        vim.list_extend(names, lint.linters_by_ft['*'] or {})
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            vim.notify('Linter not found: ' .. name, vim.log.levels.WARN, { title = 'nvim-lint' })
          end
          return linter and not (type(linter) == 'table' and linter.condition and not linter.condition(ctx))
        end, names)
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
  },
}
