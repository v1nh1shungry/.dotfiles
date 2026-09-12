vim.opt_local.wrap = true

Dotfiles.map({ "0", "g0", buffer = true, desc = "To first character of screen line", mode = { "n", "x" } })
Dotfiles.map({ "$", "g$", buffer = true, desc = "To last character of screen line", mode = { "n", "x" } })
Dotfiles.map({ "g0", "0", buffer = true, desc = "To first character of line", mode = { "n", "x" } })
Dotfiles.map({ "g$", "$", buffer = true, desc = "To last character of line", mode = { "n", "x" } })
