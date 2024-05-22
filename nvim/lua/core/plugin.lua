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

require('lazy').setup('plugins', {
  install = { colorscheme = { require('user').ui.colorscheme } },
  performance = {
    rtp = {
      disabled_plugins = {
        'editorconfig',
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'osc52',
        'rplugin',
        'spellfile',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
