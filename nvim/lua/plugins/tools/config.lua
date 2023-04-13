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

M.autolist = function()
  local autolist = require('autolist')
  autolist.setup()
  autolist.create_mapping_hook('i', '<CR>', autolist.new)
  autolist.create_mapping_hook('i', '<Tab>', autolist.indent)
  autolist.create_mapping_hook('i', '<S-Tab>', autolist.indent, '<C-d>')
  autolist.create_mapping_hook('n', 'o', autolist.new)
  autolist.create_mapping_hook('n', 'O', autolist.new_before)
  autolist.create_mapping_hook('n', '>>', autolist.indent)
  autolist.create_mapping_hook('n', '<<', autolist.indent)
  autolist.create_mapping_hook('n', '<leader>x', autolist.invert_entry, '')
  vim.api.nvim_create_autocmd('TextChanged', {
    callback = function()
      vim.cmd.normal { autolist.force_recalculate(nil, nil), bang = false }
    end,
    pattern = '*',
  })
end

return M
