local M = {
  plugins = {
    user = {},
    extra = {},
  },
  ui = {
    background = "dark",
    blend = 10,
    colorscheme = "tokyonight",
  },
  task = {
    save = true,
    compile = {},
    execute = {},
    launch = {},
  },
}

local filename = vim.fs.joinpath(os.getenv("HOME"), ".nvimrc")
if vim.fn.filereadable(filename) ~= 0 then
  M = vim.tbl_deep_extend("force", M, dofile(filename))
else
  local content = { "-- vim:ft=lua" }
  local default_config = vim.split(vim.inspect(M), "\n")
  default_config[1] = "return " .. default_config[1]
  vim.list_extend(content, default_config)
  require("dotfiles.utils.file").write(content, filename)
end

return M
