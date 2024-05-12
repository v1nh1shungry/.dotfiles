local M = {}

M.enter_buffer = {
  'BufNewFile',
  'BufReadPost',
}

M.enter_insert = {
  'InsertEnter',
  'CmdlineEnter',
}

return M
