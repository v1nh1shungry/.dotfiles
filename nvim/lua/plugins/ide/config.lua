local M = {}

local on_attach = function(client, bufnr)
  local keymap = function(modes, from, to)
    vim.keymap.set(modes, from, to, { noremap = true, silent = true, buffer = bufnr })
  end

  keymap('n', '=', function() vim.lsp.buf.format { async = true, bufnr = bufnr } end)
  keymap('n', '<Leader>rn', '<Cmd>Lspsaga rename<CR>')
  keymap('n', 'gh', vim.lsp.buf.hover)
  keymap({ 'n', 'v' }, '<Leader>ca', '<Cmd>Lspsaga code_action<CR>')
  keymap('n', '<Leader>o', '<Cmd>Lspsaga outline<CR>')
  keymap('n', ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>')
  keymap('n', '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>')
  keymap('n', 'gd', '<Cmd>Glance definitions<CR>')
  keymap('n', 'gy', '<Cmd>Glance type_definitions<CR>')
  keymap('n', 'gR', '<Cmd>Glance references<CR>')

  if client.supports_method('textDocument/rangeFormatting') then
    keymap('v', '=', function() vim.lsp.buf.format({ async = true }) end)
  end

  require('lsp_signature').on_attach {
    bind = true,
    hint_enable = false,
    hi_parameter = 'IncSearch',
    handler_opts = { border = 'none' },
  }
end

M.lspconfig = function()
  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  local servers = {
    'bashls',
    'jsonls',
    'marksman',
    'neocmake',
    'pyright',
    'rust_analyzer',
    'tsserver',
  }

  require('mason-lspconfig').setup { automatic_installation = { exclude = { 'clangd' } } }

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
        '--header-insertion=never',
        '--include-cleaner-stdlib',
        '--offset-encoding=utf-16', -- compatible with `null-ls`
      },
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
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
        format = {
          defaultConfig = {
            trailing_table_separator = 'smart',
            align_call_args = true,
          },
        },
      },
    },
  }

  lspconfig.ocamllsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    single_file_support = true,
  }
end

M.null_ls = function()
  local actions = require('null-ls').builtins.code_actions
  local diagnostics = require('null-ls').builtins.diagnostics
  local formatting = require('null-ls').builtins.formatting

  require('null-ls').setup {
    sources = {
      actions.gitsigns,
      actions.gitrebase,
      actions.shellcheck,
      diagnostics.fish,
      diagnostics.rstcheck,
      diagnostics.trail_space,
      formatting.autopep8,
      formatting.fish_indent,
      formatting.shfmt,
      formatting.trim_newlines,
      formatting.trim_whitespace,
    },
    on_attach = on_attach,
    update_in_insert = true,
  }

  require('mason-null-ls').setup { automatic_installation = true }
end

M.cmp = function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  cmp.setup {
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    window = { completion = { side_padding = 0 } },
    experimental = { ghost_text = true },
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
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-k>'] = cmp.mapping.select_prev_item(),
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
    }, {
      { name = 'buffer' },
      { name = 'path' },
      { name = 'rg',    keyword_length = 5 },
    })
  }

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources { { name = 'cmdline' }, { name = 'path' } },
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources { { name = 'buffer' } },
  })
end

M.tree = function()
  require('neo-tree').setup {
    close_if_last_window = true,
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_hidden = false,
        hide_by_name = { '.git', 'node_modules', 'build' },
      },
      hijack_netrw_behavior = 'disabled',
    },
    window = {
      mappings = {
        ['h'] = 'close_node',
        ['l'] = function(state)
          local node = state.tree:get_node()
          if node.type == 'directory' and not node:is_expanded() then
            require('neo-tree.sources.filesystem').toggle_directory(state, node)
          elseif node.type == 'file' then
            require('neo-tree.sources.filesystem.commands').open(state)
          end
        end,
      },
    },
    event_handlers = {
      {
        event = 'file_opened',
        handler = function(_) require('neo-tree').close_all() end
      },
    },
  }
end

M.dap = function()
  local dap, dapui = require('dap'), require('dapui')
  local icons = require('utils.icons').dap

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
    automatic_setup = true,
  }
  require('mason-nvim-dap').setup_handlers {
    codelldb = function(source_name)
      require('mason-nvim-dap.automatic_setup')(source_name)

      local standalone = require('plugins.ide.dap.standalone')
      dap.configurations.c = standalone.c
      dap.configurations.cpp = standalone.cpp
      dap.configurations.rust = standalone.rust
      dap.configurations.zig = standalone.zig
    end
  }
end

M.lspsaga = function()
  require('lspsaga').setup {
    code_action = {
      keys = { quit = '<ESC>' },
      extend_gitsigns = false,
    },
    lightbulb = { sign = false },
    diagnostic = {
      on_insert = false,
      show_code_action = false,
    },
    rename = { quit = '<ESC>' },
    symbol_in_winbar = { separator = ' > ' },
    ui = { border = 'rounded' },
  }
end

M.gitsigns = function()
  local gitsigns = require('gitsigns')
  local nnoremap = require('utils.keymaps').nnoremap
  gitsigns.setup()
  nnoremap(']h', gitsigns.next_hunk)
  nnoremap('[h', gitsigns.prev_hunk)
end

return M
