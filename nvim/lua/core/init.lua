require 'core.autocmds'
require 'core.keymaps'
require 'core.options'

if vim.g.neovide == nil then
  vim.g.clipboard = {
    name = 'win32yank-WSL',
    copy = {
      ['+'] = '/mnt/d/wslutils/win32yank.exe -i --crlf',
      ['*'] = '/mnt/d/wslutils/win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = '/mnt/d/wslutils/win32yank.exe -o --lf',
      ['*'] = '/mnt/d/wslutils/win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
else
  require 'core.gui'
end
