local default = require('user.default')
local config = dofile(os.getenv('HOME') .. '/.nvimrc.lua')
if config ~= nil then
  return vim.tbl_deep_extend('force', default, config)
else
  return default
end
