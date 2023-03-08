local M = {}

M.enter_buffer = {
  'BufNewFile',
  'BufReadPre',
}

M.enter_insert = {
  'InsertEnter',
  'CmdlineEnter',
}

return M
