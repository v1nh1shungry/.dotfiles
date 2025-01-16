_G.Dotfiles = require("dotfiles.utils")

vim.filetype.add({
  filename = {
    [".nvimrc"] = "lua",
  },
  pattern = {
    [".*/kitty/.+%.conf"] = "kitty",
    ["%.env%.[%w_.-]+"] = "sh",
  },
})
vim.treesitter.language.register("bash", "kitty")

require("dotfiles.core.autocmds")
require("dotfiles.core.keymaps")
require("dotfiles.core.options")
require("dotfiles.core.lazy")
require("dotfiles.core.ui")
