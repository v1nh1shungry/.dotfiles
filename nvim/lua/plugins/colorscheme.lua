local M = {}

M.colorscheme = 'nightfox'

function M.setup()
  vim.opt.background = 'dark'
  vim.cmd('colorscheme ' .. M.colorscheme)
end

return M
