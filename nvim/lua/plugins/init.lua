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

-- Bootstrap hotpot.nvim
local hotpot_path = vim.fn.stdpath('data') .. '/lazy/hotpot.nvim'
if not vim.loop.fs_stat(hotpot_path) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/rktjmp/hotpot.nvim.git',
    hotpot_path,
  })
end
vim.opt.runtimepath:prepend(hotpot_path)

local modules = { 'core', 'ide', 'ui', 'tools', 'themes' }
local lazy_specs = {
  {
    'rktjmp/hotpot.nvim',
    event = 'VeryLazy',
  },
}

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

require('hotpot').setup { provide_require_fennel = true }
