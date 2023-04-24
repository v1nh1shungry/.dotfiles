-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local modules = { 'core', 'ide', 'ui', 'tools', 'themes' }
local lazy_specs = {}

for _, module in ipairs(modules) do
  local module_specs = require('plugins.' .. module)
  for _, spec in ipairs(module_specs) do
    lazy_specs[#lazy_specs + 1] = spec
  end
end

for _, spec in ipairs(require('user').plugins) do
  lazy_specs[#lazy_specs + 1] = spec
end

require('lazy').setup(lazy_specs, {
  install = { colorscheme = { require('user').ui.colorscheme } },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
