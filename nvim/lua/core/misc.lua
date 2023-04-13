vim.cmd 'filetype plugin indent on'
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd([[syntax enable]]) end

if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = '/mnt/d/scoop/apps/win32yank/current/win32yank.exe -i --crlf',
      ['*'] = '/mnt/d/scoop/apps/win32yank/current/win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = '/mnt/d/scoop/apps/win32yank/current/win32yank.exe -o --lf',
      ['*'] = '/mnt/d/scoop/apps/win32yank/current/win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
end

local icons = require('utils.icons').diagnostics
local signs = {
  { name = 'DiagnosticSignError', text = icons.error },
  { name = 'DiagnosticSignWarn', text = icons.warning },
  { name = 'DiagnosticSignHint', text = icons.hint },
  { name = 'DiagnosticSignInfo', text = icons.info },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

vim.diagnostic.config {
  signs = { active = signs },
  update_in_insert = true,
  severity_sort = true,
}

vim.g.markdown_recommended_style = 0
