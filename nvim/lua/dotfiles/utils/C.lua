---@class dotfiles.utils.C
local M = {}

local ffi = require("ffi")

ffi.cdef([[
const char *gnu_get_libc_version();
int lockf(int fd, int cmd, long len);
]])

local GLIBC_VERSION = ffi.string(ffi.C.gnu_get_libc_version())

---@return string
function M.glibc_version() return GLIBC_VERSION end

---@param fd integer
---@param enable? boolean
---@return integer
function M.lock(fd, enable) return ffi.C.lockf(fd, enable and 2 or 0, 0) end

return M
