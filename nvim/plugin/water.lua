local timer = vim.loop.new_timer()
local minute = require('user').water.minute

timer:start(
  minute * 60 * 1000,
  minute * 60 * 1000,
  vim.schedule_wrap(function()
    vim.notify(require('user').water.message, vim.log.levels.WARN, {
      title = 'You',
      timeout = false,
      on_open = function() timer:stop() end,
      on_close = function() timer:again() end,
    })
  end)
)
