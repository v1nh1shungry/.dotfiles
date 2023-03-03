local M = {}
local default = require('user.default')
local old_package_path = package.path
package.path = os.getenv('HOME') .. '/.nvimrc.lua;' .. old_package_path
local status_ok, config = pcall(require, '.nvimrc')
package.path = old_package_path
if status_ok then
  M = vim.tbl_deep_extend('force', default, config)
else
  config = default
end
return M
