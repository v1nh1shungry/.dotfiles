local default = {
  g = {},
  lsp = { format_on_save = false },
  plugins = {
    disabled = {},
    extra = {},
  },
  ui = {
    background = 'dark',
    blend = 10,
    colorscheme = 'tokyonight',
    statusline_theme = 'vscode',
  },
}

local config = dofile(os.getenv('HOME') .. '/.nvimrc')
if config ~= nil then
  return vim.tbl_deep_extend('force', default, config)
else
  return default
end
