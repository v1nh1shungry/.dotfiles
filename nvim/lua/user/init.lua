local init_impl = function()
  local config = nil

  return function()
    if config == nil then
      local default = require('user.default')
      local old_package_path = package.path
      package.path = os.getenv('HOME') .. '/.nvimrc.lua;' .. old_package_path
      local status_ok, data = pcall(require, '.nvimrc')
      if not status_ok then data = default end
      package.path = old_package_path
      config = vim.tbl_deep_extend('force', default, data)
    end
    return config
  end
end

local init = init_impl()
return init()
