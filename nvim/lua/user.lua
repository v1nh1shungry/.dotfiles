local M = {
  plugins = {
    disabled = {},
    extra = {},
    langs = {},
  },
  ui = {
    background = 'dark',
    blend = 10,
    colorscheme = 'tokyonight',
    statusline_theme = 'vscode',
  },
}

local setup = function()
  vim.cmd.colorscheme(M.ui.colorscheme)
end

local filename = os.getenv('HOME') .. '/.nvimrc'
if vim.fn.filereadable(filename) then
  M = vim.tbl_deep_extend('force', M, dofile(filename))
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
