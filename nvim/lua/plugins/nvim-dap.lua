return function()
  vim.cmd [[packadd nvim-dap-ui]]
  vim.cmd [[packadd nvim-dap-virtual-text]]

  local dap, dapui = require('dap'), require('dapui')

  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
  vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
  vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })

  dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
  dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
  dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

  dapui.setup()
  require('nvim-dap-virtual-text').setup()

  local nnoremap = require('utils.keymaps').nnoremap
  nnoremap('<F9>', '<Cmd>DapToggleBreakpoint<CR>')
  nnoremap('<F5>', '<Cmd>DapContinue<CR>')
  nnoremap('<F10>', '<Cmd>DapStepOver<CR>')
  nnoremap('<F11>', '<Cmd>DapStepInto<CR>')
  nnoremap('<F12>', '<Cmd>DapStepOut<CR>')

  -- Debug Adapters
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb',
      args = { '--port', '${port}' },
    },
  }

  -- Debug Configurations
  dap.configurations.cpp = {
    {
      name = 'Standalone',
      type = 'codelldb',
      request = 'launch',
      program = '${fileBasenameNoExtension}',
      cwd = '${workspaceFolder}',
    },
  }

  dap.configurations.c = dap.configurations.cpp
end
