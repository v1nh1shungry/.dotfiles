local M = {}

local setup_keymaps = function(client, bufnr)
  local keymap = function(modes, from, to)
    vim.keymap.set(modes, from, to, { noremap = true, silent = true, buffer = bufnr })
  end

  keymap('n', '=', function() vim.lsp.buf.format { async = true, bufnr = bufnr } end)
  keymap('n', '<Leader>rn', vim.lsp.buf.rename)
  keymap('n', 'gh', '<Cmd>Lspsaga hover_doc<CR>')
  keymap({ 'n', 'v' }, '<Leader>ca', '<Cmd>Lspsaga code_action<CR>')
  keymap('n', '<Leader>o', '<Cmd>Lspsaga outline<CR>')
  keymap('n', ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>')
  keymap('n', '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>')
  keymap('n', 'gd', '<Cmd>Trouble lsp_definitions<CR>')
  keymap('n', 'gy', '<Cmd>Trouble lsp_type_definitions<CR>')
  keymap('n', 'gr', '<Cmd>Trouble lsp_references<CR>')

  if client.supports_method('textDocument/rangeFormatting') then
    keymap('v', '=', function() vim.lsp.buf.format({ async = true }) end)
  end
end

local on_attach = function(client, bufnr)
  setup_keymaps(client, bufnr)
  require('lsp_signature').on_attach { hint_enable = false, hi_parameter = 'IncSearch' }
end

M.lspconfig = function()
  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  local servers = {
    'bashls',
    'cmake',
    'gopls',
    'grammarly',
    'pyright',
    'rust_analyzer',
    'zls',
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
        '--header-insertion=never',
        '--include-cleaner-stdlib',
        '--offset-encoding=utf-16', -- compatible with `null-ls`
      },
    },
    extensions = { autoSetHints = false },
  }

  lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
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

  lspconfig.ds_pinyin_lsp.setup {
    init_options = {
      db_path = vim.fn.stdpath('data') .. '/ds-pinyin-lsp/dict.db3',
      completion_on = true,
      match_as_same_as_input = true,
    },
  }
end

M.null_ls = function()
  local actions = require('null-ls').builtins.code_actions
  local diagnostics = require('null-ls').builtins.diagnostics
  local formatting = require('null-ls').builtins.formatting

  require('null-ls').setup {
    sources = {
      actions.gitrebase,
      actions.shellcheck,
      diagnostics.cmake_lint,
      diagnostics.fish,
      diagnostics.trail_space,
      formatting.autopep8,
      formatting.cmake_format,
      formatting.fish_indent,
      formatting.markdown_toc,
      formatting.shfmt,
      formatting.trim_newlines,
      formatting.trim_whitespace,
    },
    on_attach = on_attach,
    update_in_insert = true,
  }
end

M.mason = function()
  require('mason').setup()
  require('mason-lspconfig').setup {
    ensure_installed = {
      'bashls',
      'cmake',
      'gopls',
      'grammarly',
      'jsonls',
      'lua_ls',
      'pyright',
      'rust_analyzer',
      'zls',
    },
  }
  require('mason-tool-installer').setup {
    ensure_installed = {
      'autopep8',
      'cmakelang',
      'shellcheck',
      'shfmt',
    },
  }
end

M.cmp = function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  cmp.setup {
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    formatting = { format = require('lspkind').cmp_format { mode = 'symbol_text', maxwidth = 50 } },
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
        if luasnip.jumpable( -1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'rg',      keyword_length = 5 },
    },
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
    source_selector = { winbar = true },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = { '.git' },
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

  dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
  dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
  dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

  dapui.setup {
    icons = { expanded = '', collapsed = '', current_frame = '' },
    controls = {
      icons = {
        pause = icons.pause,
        play = icons.play,
        run_last = icons.run_last,
        step_back = icons.step_back,
        step_into = icons.step_into,
        step_out = icons.step_out,
        step_over = icons.step_over,
        terminate = icons.terminate,
      },
    },
  }

  local nnoremap = require('utils.keymaps').nnoremap
  nnoremap('<F10>', '<Cmd>DapStepOver<CR>')
  nnoremap('<F11>', '<Cmd>DapStepInto<CR>')
  nnoremap('<F12>', '<Cmd>DapStepOut<CR>')

  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb',
      args = { '--port', '${port}' },
    },
  }

  local standalone = require('plugins.ide.dap.standalone')
  dap.configurations.c = standalone.c
  dap.configurations.cpp = standalone.cpp
  dap.configurations.rust = standalone.rust
  dap.configurations.zig = standalone.zig
end

M.lspsaga = function()
  require('lspsaga').setup {
    code_action = { keys = { quit = '<ESC>' } },
    lightbulb = { sign = false },
    diagnostic = { show_code_action = false },
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
