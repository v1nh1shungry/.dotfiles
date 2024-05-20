local timer = vim.loop.new_timer()
local minute = 30

timer:start(
  minute * 60 * 1000,
  minute * 60 * 1000,
  vim.schedule_wrap(function()
    vim.notify(' ⏰ Time to stand up, drink some water and go to the bathroom', vim.log.levels.WARN, {
      title = 'You',
      timeout = false,
      on_open = function() timer:stop() end,
      on_close = function() timer:again() end,
    })
  end)
)
