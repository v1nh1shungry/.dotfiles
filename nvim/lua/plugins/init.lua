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

local lazy_specs = {}

for _, module in ipairs { 'core', 'ide', 'ui', 'tools', 'themes' } do
  local module_specs = require('plugins.' .. module)
  for _, spec in ipairs(module_specs) do
    lazy_specs[#lazy_specs + 1] = spec
  end
end

for _, spec in ipairs(require('user').plugins.extra) do
  lazy_specs[#lazy_specs + 1] = spec
end
for _, plugin in ipairs(require('user').plugins.disabled) do
  lazy_specs[#lazy_specs + 1] = { plugin, enabled = false }
end

require('lazy').setup {
  spec = lazy_specs,
  install = { colorscheme = { require('user').ui.colorscheme } },
  performance = {
    rtp = {
      disabled_plugins = {
        'editorconfig',
        'gzip',
        'man',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'nvim',
        'rplugin',
        'shada',
        'spellfile',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}

require('user').setup()
