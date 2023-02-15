local M = {}

M.enter_buffer = {
  'BufNewFile',
  'BufRead',
}

M.enter_insert = {
  'InsertEnter',
  'CmdlineEnter',
}

return M
