local M = setmetatable({}, { __index = require("plenary.async") })

---@async
---@type fun(cmd: string[], opts?: vim.SystemOpts): vim.SystemCompleted
M.system = M.wrap(vim.system, 3)

---@async
---@type fun(opts?: snacks.input.Opts): string?
M.input = M.wrap(vim.schedule_wrap(vim.ui.input), 2)

M.fn = setmetatable({}, {
  __index = function(_, k)
    return function(...)
      if vim.in_fast_event() then
        M.util.scheduler()
      end

      return vim.fn[k](...)
    end
  end,
})

return M
