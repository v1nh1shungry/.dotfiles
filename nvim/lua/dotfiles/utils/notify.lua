---@class dotfiles.utils.Notify
---@field debug fun(msg: string, ...)
---@field error fun(msg: string, ...)
---@field info fun(msg: string, ...)
---@field warn fun(msg: string, ...)
---@field off fun(msg: string, ...)
---@field trace fun(msg: string, ...)
local M = {}

for k, v in pairs(vim.log.levels) do
  ---@param msg string
  M[k:lower()] = function(msg, ...)
    local args = vim.F.pack_len(...)
    if args.n ~= 0 then msg = string.format(msg, vim.F.unpack_len(args)) end
    vim.notify(msg, v, { title = "Dotfiles" })
  end
end

return M
