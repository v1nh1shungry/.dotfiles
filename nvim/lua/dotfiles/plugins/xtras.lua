return vim
  .iter(Dotfiles.user.extra)
  :map(function(spec)
    local extra = "dotfiles.plugins.extra." .. spec

    if type(spec) == "string" and vim.F.npcall(require, extra) then
      return { import = extra }
    end

    return spec
  end)
  :totable()
