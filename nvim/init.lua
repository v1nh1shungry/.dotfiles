-- TODO: add luacats docs

_G.Dotfiles = require("dotfiles.utils")

if Dotfiles.user.repro.enabled then
  require("dotfiles.repro")
else
  require("dotfiles.core")
end
