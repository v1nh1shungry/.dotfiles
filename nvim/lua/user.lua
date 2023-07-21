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
local function tbl_extend(lhs, rhs)
  if not rhs then
    return lhs
  end
  for k, _ in pairs(lhs) do
    if type(lhs[k]) == 'table' then
      lhs[k] = tbl_extend(lhs[k], rhs[k])
    else
      if rhs[k] then
        lhs[k] = rhs[k]
      end
    end
  end
  return lhs
end
if vim.fn.filereadable(filename) then
  tbl_extend(M, dofile(filename))
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
