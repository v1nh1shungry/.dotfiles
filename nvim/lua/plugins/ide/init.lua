local events = require('utils.events')

local M = {
  {
    'neovim/nvim-lspconfig',
    config = function(_, lsp_opts)
      local on_attach = function(client, bufnr)
        local format = function() vim.lsp.buf.format { buffer = bufnr } end
        local map = function(opts)
          local lhs, rhs, mode = opts[1], opts[2], opts.mode
          opts[1], opts[2], opts.mode = nil, nil, nil
          vim.tbl_extend('force', { buffer = bufnr, noremap = true, silent = true }, opts)
          vim.keymap.set(mode or 'n', lhs, rhs, opts)
        end

        local mappings = {
          ['textDocument/formatting'] = { { '<Leader>cf', format, desc = 'Format document' } },
          ['textDocument/rangeFormatting'] = { { '<Leader>cf', format, desc = 'Format range', mode = 'v' } },
          ['textDocument/rename'] = { { '<Leader>cr', '<Cmd>Lspsaga rename<CR>', desc = 'Rename' } },
          ['textDocument/codeAction'] = { { '<Leader>ca', '<Cmd>Lspsaga code_action<CR>', desc = 'Code action' } },
          ['textDocument/documentSymbol'] = {
            { '<Leader>uo', '<Cmd>Lspsaga outline<CR>',                desc = 'Symbol outline' },
            { '<Leader>ss', '<Cmd>Telescope lsp_document_symbols<CR>', desc = 'Browse LSP symbols' },
          },
          ['textDocument/references'] = { { 'gR', '<Cmd>Glance references<CR>', desc = 'Go to references' } },
          ['textDocument/definition'] = { { 'gd', '<Cmd>Glance definitions<CR>', desc = 'Go to definition' } },
          ['textDocument/typeDefinition*'] = { { 'gy', '<Cmd>Glance type_definitions<CR>', desc = 'Go to type definition' } },
          ['textDocument/implementation*'] = { { 'gi', '<Cmd>Glance implementations<CR>', desc = 'Go to implementation' } },
          ['callHierarchy/incomingCalls'] = { { '<Leader>ci', '<Cmd>Lspsaga incoming_calls<CR>', desc = 'Incoming calls' } },
          ['callHierarchy/outgoingCalls'] = { { '<Leader>co', '<Cmd>Lspsaga outgoing_calls<CR>', desc = 'Outgoing calls' } },
        }
        for _, key in ipairs({
          { '<Leader>cd', '<Cmd>Lspsaga show_line_diagnostics<CR>', desc = 'Show line diagnostics' },
          { ']d',         '<Cmd>Lspsaga diagnostic_jump_next<CR>',  desc = 'Next diagnostic' },
          { '[d',         '<Cmd>Lspsaga diagnostic_jump_prev<CR>',  desc = 'Previous diagnostic' },
          {
            ']e',
            function() require('lspsaga.diagnostic'):goto_next { severity = vim.diagnostic.severity.ERROR } end,
            desc = 'Next error',
          },
          {
            '[e',
            function() require('lspsaga.diagnostic'):goto_prev { severity = vim.diagnostic.severity.ERROR } end,
            desc = 'Previous error',
          },
          { '<Leader>xx', '<Cmd>TroubleToggle<CR>', desc = 'Document diagnostics' },
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

      local icons = require('utils.ui').icons.diagnostics
      local signs = {
        { name = 'DiagnosticSignError', text = icons.error },
        { name = 'DiagnosticSignWarn',  text = icons.warning },
        { name = 'DiagnosticSignHint',  text = icons.hint },
        { name = 'DiagnosticSignInfo',  text = icons.info },
      }
      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
      end

      vim.diagnostic.config(vim.deepcopy(lsp_opts.diagnostics))

      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )

      for server, opts in pairs(lsp_opts.servers) do
        opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
          single_file_support = true,
        }, opts)
        if opts.setup then
          opts.setup(server, opts)
        else
          require('lspconfig')[server].setup(opts)
        end
      end
    end,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      {
        'folke/neodev.nvim',
        config = true,
      },
      'p00f/clangd_extensions.nvim',
      'williamboman/mason-lspconfig.nvim',
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
            { '<Leader>ct', '<Cmd>ClangAST<CR>',                 desc = 'Clangd AST' },
            { '<Leader>cs', '<Cmd>ClangdSwitchSourceHeader<CR>', desc = 'Switch between source and header' },
          },
          setup = function(_, opts)
            require('clangd_extensions').setup {
              server = opts,
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
          end,
        },
        lua_ls = {
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
        },
        yamlls = { settings = { yaml = { keyOrdering = false } } },
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
      symbol_in_winbar = { enable = false },
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
          { name = 'rg',    keyword_length = 3 },
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
    end,
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      {
        'saadparwaiz1/cmp_luasnip',
        dependencies = 'L3MON4D3/LuaSnip',
      },
      'onsails/lspkind.nvim',
      'lukas-reineke/cmp-rg',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-emoji',
    },
    event = events.enter_insert,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = true,
    event = events.enter_buffer,
    keys = {
      { '<Leader>gp', '<Cmd>Gitsigns preview_hunk<CR>',               desc = 'Preview git hunk' },
      { '<Leader>gr', '<Cmd>Gitsigns reset_hunk<CR>',                 desc = 'Reset git hunk' },
      { '<Leader>gd', '<Cmd>Gitsigns diffthis<CR>',                   desc = 'Git diffthis' },
      { ']h',         function() require('gitsigns').next_hunk() end, desc = 'Next git hunk' },
      { '[h',         function() require('gitsigns').prev_hunk() end, desc = 'Previous git hunk' },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    keys = {
      '<M-=>',
      { '<Leader>gD', function() require('plugins.ide.toggleterm.git_diff')() end, desc = 'Git diff' },
    },
    opts = { open_mapping = '<M-=>', size = 10 },
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
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
    end,
    dependencies = {
      'rcarriga/nvim-dap-ui',
      {
        'theHamsta/nvim-dap-virtual-text',
        config = true,
      },
      'jay-babu/mason-nvim-dap.nvim',
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
    cmd = { 'TroubleToggle', 'TodoTrouble' },
  },
  {
    'DNLHC/glance.nvim',
    cmd = 'Glance',
  },
  {
    'echasnovski/mini.files',
    config = function()
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
    end,
    keys = { { '<Leader>e', function() MiniFiles.open() end, desc = 'Explorer' } },
  },
  {
    'Bekaboo/dropbar.nvim',
    event = events.enter_buffer,
    keys = { { 'gw', function() require('dropbar.api').pick() end, desc = 'Pick winbar symbol' } },
  },
}

for _, lang in ipairs(require('user').plugins.langs) do
  for _, spec in ipairs(require('plugins.ide.lang.' .. lang)) do
    M[#M + 1] = spec
  end
end

return M
