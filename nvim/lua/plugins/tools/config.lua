local M = {}

M.asynctasks = function()
  vim.g.asyncrun_open = 10
  vim.g.asynctasks_term_rows = 10
  vim.g.asynctasks_term_pos = 'bottom'
end

return M
