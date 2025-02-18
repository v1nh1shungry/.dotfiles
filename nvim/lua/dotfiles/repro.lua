vim.env.LAZY_STDPATH = Dotfiles.user.repro.stdpath

local BOOTSTRAP = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim", "bootstrap.lua")
if vim.fn.filereadable(BOOTSTRAP) == 1 then
  loadfile(vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim", "bootstrap.lua"))()
else
  load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()
end

require("lazy.minit").repro({ spec = Dotfiles.user.repro.spec })

if Dotfiles.user.repro.setup then
  Dotfiles.user.repro.setup()
end
