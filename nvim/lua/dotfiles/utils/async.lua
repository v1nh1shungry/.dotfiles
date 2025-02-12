local M = setmetatable({}, { __index = require("plenary.async") })

M.system = M.wrap(vim.system, 3)

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
