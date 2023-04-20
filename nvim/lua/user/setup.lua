local config = require('user')

for k, v in pairs(require('user').g) do
  vim.g[k] = v
end

vim.cmd.colorscheme(config.colorscheme)
