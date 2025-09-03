vim.opt_local.wrap = true

Dotfiles.map({ "<Leader>qq", "<Cmd>cquit<CR>", buffer = true, desc = "Abort" })
Dotfiles.map({ "<Leader>qQ", "ZZ", buffer = true, desc = "Confirm" })
Dotfiles.map({ "<Leader>gd", "<Cmd>DiffGitCached<CR>", buffer = true, desc = "Show Cached Diff" })
