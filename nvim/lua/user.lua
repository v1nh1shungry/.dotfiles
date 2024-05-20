local M = {
  plugins = {},
  ui = {
    background = 'dark',
    blend = 10,
    colorscheme = 'tokyonight',
  },
  task = {
    save = true,
    compile = {},
    execute = {},
  },
}

local setup = function()
  vim.cmd.colorscheme(M.ui.colorscheme)
end

local filename = vim.fs.joinpath(os.getenv('HOME'), '.nvimrc')
if vim.fn.filereadable(filename) ~= 0 then
  M = vim.tbl_deep_extend('force', M, dofile(filename))
else
  vim.fn.writefile({ '-- vim:ft=lua' }, filename, 'a')
  local default_config = vim.split(vim.inspect(M), '\n')
  default_config[1] = 'return ' .. default_config[1]
  vim.fn.writefile(default_config, filename, 'a')
end

if M.setup then
  local user_setup = M.setup
  M.setup = function()
    setup()
    user_setup()
  end
else
  M.setup = setup
end

return M
