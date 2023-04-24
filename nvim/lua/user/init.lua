local default = {
  g = {},
  plugins = {},
  ui = {
    blend = 10,
    colorscheme = 'darkplus',
    statusline_theme = 'vscode',
  },
}

local config = dofile(os.getenv('HOME') .. '/.nvimrc')
if config ~= nil then
  return vim.tbl_deep_extend('force', default, config)
else
  return default
end
