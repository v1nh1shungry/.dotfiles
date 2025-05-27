---@alias dotfiles.utils.Notifier fun(msg: string, ...)

---@class dotfiles.utils.Notify
---@field debug dotfiles.utils.Notifier
---@field error dotfiles.utils.Notifier
---@field info dotfiles.utils.Notifier
---@field warn dotfiles.utils.Notifier
---@field off dotfiles.utils.Notifier
---@field trace dotfiles.utils.Notifier
local M = {}

for k, v in pairs(vim.log.levels) do
  ---@param msg string
  M[k:lower()] = function(msg, ...)
    local args = vim.F.pack_len(...)
    if args.n ~= 0 then
      msg = msg:format(vim.F.unpack_len(args))
    end

    vim.notify(msg, v, { title = "Dotfiles" })
  end
end

return setmetatable(M, {
  __call = function(_, ...) M.info(...) end,
})
