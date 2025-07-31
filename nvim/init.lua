-- clean loader cache without corresponding file.
local luac_path = vim.fs.joinpath(vim.fn.stdpath("cache"), "luac")
for name, type in vim.fs.dir(luac_path) do
  if type == "file" then
    if not vim.uv.fs_stat(vim.uri_decode(name):sub(1, -2)) then
      vim.fs.rm(vim.fs.joinpath(luac_path, name))
    end
  end
end

require("dotfiles.core")
