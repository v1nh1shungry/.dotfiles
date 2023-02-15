local config = require('user')

if not vim.g.started_by_firenvim then
  vim.cmd('colorscheme ' .. config.colorscheme.terminal)
else
  vim.cmd('colorscheme ' .. config.colorscheme.firenvim)
end
