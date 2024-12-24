local M = {
  extra = {},
  ui = {
    background = "dark",
    blend = 10,
    colorscheme = "tokyonight",
  },
  task = {
    save = true,
    compile = {},
    execute = {},
  },
  nightly = false,
}

local filename = vim.fs.joinpath(os.getenv("HOME"), ".nvimrc")
if vim.fn.filereadable(filename) ~= 0 then
  M = vim.tbl_deep_extend("force", M, dofile(filename))
else
  local default_config = vim.split(vim.inspect(M), "\n")
  default_config[1] = "return " .. default_config[1]
  vim.fn.writefile(default_config, filename)
end

return M
