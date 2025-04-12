return vim.iter(Dotfiles.user.lang):map(function(l) return require("dotfiles.plugins.lang." .. l) end):totable()
