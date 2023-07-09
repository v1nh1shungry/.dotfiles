local M = {
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

local setup = function()
  vim.cmd.colorscheme(M.ui.colorscheme)
end

M = vim.tbl_extend('keep', M, dofile(os.getenv('HOME') .. '/.nvimrc') or {})
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
