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

local modules = {}
local config = require('user').mode
local lazy_specs = {}

if config == 'minimal' then
  modules = { 'core', 'themes' }
elseif config == 'ide' then
  modules = { 'core', 'ide', 'themes' }
else
  modules = { 'core', 'ide', 'ui', 'tools', 'themes' }
end

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
  install = { colorscheme = { require('user').colorscheme } },
  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'editorconfig',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'health',
        'logipat',
        'man',
        'matchit',
        'matchparen',
        'netrw',
        'netrwFileHandlers',
        'netrwPlugin',
        'netrwSettings',
        'nvim',
        'rplugin',
        'rrhelper',
        'shada',
        'spec',
        'spellfile',
        'spellfile_plugin',
        'tar',
        'tarPlugin',
        'tohtml',
        'tutor',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
      },
    },
  },
})
