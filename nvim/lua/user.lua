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
