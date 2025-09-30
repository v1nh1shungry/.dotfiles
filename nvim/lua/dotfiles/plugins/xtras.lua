return vim.list_extend(
  vim
    .iter(Dotfiles.user.extra)
    :map(function(spec)
      if type(spec) == "string" and vim.F.npcall(require, "dotfiles.plugins.extra." .. spec) then
        return { import = "dotfiles.plugins.extra." .. spec }
      end
      return spec
    end)
    :totable(),
  vim
    .iter(Dotfiles.user.lang)
    :map(function(l) return vim.F.npcall(require, "dotfiles.plugins.lang." .. l) or {} end)
    :totable()
)
