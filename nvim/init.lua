-- TODO: remove this check after migrating
if vim.fn.filereadable(vim.fs.joinpath(vim.env.HOME, ".nvimrc")) == 1 then
  vim.notify("Please migrate your old user config", "ERROR")
  os.exit(1)
end

require("dotfiles.core")
