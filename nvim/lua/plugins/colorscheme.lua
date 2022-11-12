local M = {}

M.colorscheme = 'enfocado'

function M.setup()
  -- nord.nvim
  vim.g.nord_contrast = true
  vim.g.nord_borders = true

  vim.opt.background = 'dark'
  vim.cmd('colorscheme ' .. M.colorscheme)
end

return M
