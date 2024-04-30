vim.cmd 'filetype plugin indent on'
if vim.fn.exists('syntax_on') ~= 1 then
  vim.cmd([[syntax enable]])
end

if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
end

vim.cmd.aunmenu 'PopUp'

local icons = require('utils.ui').icons.diagnostic
for name, icon in pairs {
  DiagnosticSignError = icons.error,
  DiagnosticSignWarn = icons.warn,
  DiagnosticSignHint = icons.hint,
  DiagnosticSignInfo = icons.info,
} do
  vim.fn.sign_define(name, { texthl = name, text = icon, numhl = '' })
end

require 'core.autocmds'
require 'core.keymaps'
require 'core.options'
