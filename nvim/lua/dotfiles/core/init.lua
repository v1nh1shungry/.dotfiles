_G.Dotfiles = require("dotfiles.utils")

vim.filetype.add({
  filename = {
    [".nvimrc"] = "lua",
  },
})

require("dotfiles.core.autocmds")
require("dotfiles.core.keymaps")
require("dotfiles.core.options")
require("dotfiles.core.lazy")
require("dotfiles.core.ui")
