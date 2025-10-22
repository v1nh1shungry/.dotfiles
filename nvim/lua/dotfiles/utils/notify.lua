---@alias dotfiles.utils.notify.Notifier fun(msg: string, ...)

---@class dotfiles.utils.Notify
---@field debug dotfiles.utils.notify.Notifier
---@field error dotfiles.utils.notify.Notifier
---@field info dotfiles.utils.notify.Notifier
---@field warn dotfiles.utils.notify.Notifier
---@field off dotfiles.utils.notify.Notifier
---@field trace dotfiles.utils.notify.Notifier
local M = setmetatable({}, {
  __call = function(self, ...) self.info(...) end,
})

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

return M
