local M = {
  plugins = {},
  ui = {
    background = {
      light = 8,
      dark = 18,
    },
    blend = 10,
    colorscheme = 'tokyonight',
  },
  task = {
    save = true,
    compile = {},
    execute = {},
  },
}

local filename = vim.fs.joinpath(os.getenv('HOME'), '.nvimrc')
if vim.fn.filereadable(filename) ~= 0 then
  M = vim.tbl_deep_extend('force', M, dofile(filename))
else
  vim.fn.writefile({ '-- vim:ft=lua' }, filename, 'a')
  local default_config = vim.split(vim.inspect(M), '\n')
  default_config[1] = 'return ' .. default_config[1]
  vim.fn.writefile(default_config, filename, 'a')
end

return M
