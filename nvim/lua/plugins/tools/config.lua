local M = {}

M.asynctasks = function()
  vim.g.asyncrun_open = 10
  vim.g.asynctasks_term_rows = 10
  vim.g.asynctasks_term_pos = 'bottom'
end

M.telescope = function()
  local telescope = require('telescope')
  telescope.setup {
    defaults = {
      prompt_prefix = '🔎 ',
      selection_caret = '➤ ',
    },
  }
end

M.eunuch = function()
  -- unavailable in neovim
  vim.api.nvim_del_user_command 'SudoEdit'
  vim.api.nvim_del_user_command 'SudoWrite'
end

return M
