return vim
  .iter(Dotfiles.user.lang)
  :map(function(l) return vim.F.npcall(require, "dotfiles.plugins.lang." .. l) or {} end)
  :totable()
