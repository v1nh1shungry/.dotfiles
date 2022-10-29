local M = {}

M.colorscheme = 'enfocado'

function M.setup()
  vim.cmd('colorscheme ' .. M.colorscheme)
end

return M
