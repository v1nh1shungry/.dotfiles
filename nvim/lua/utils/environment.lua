local M = {}
local os_name = vim.loop.os_uname().sysname

M.is_macos = os_name == 'Darwin'
M.is_linux = os_name == 'Linux'
M.is_windows = os_name == 'Windows_NT'
M.is_wsl = vim.fn.has('wsl') == 1

return M
