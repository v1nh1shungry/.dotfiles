local M = {}

M.cpp = {
  {
    name = 'standalone',
    type = 'codelldb',
    request = 'launch',
    program = '${fileBasenameNoExtension}',
    cwd = '${workspaceFolder}',
  },
}

M.c = M.cpp
M.rust = M.cpp
M.zig = M.cpp

return M
