local git_diff = require('toggleterm.terminal').Terminal:new {
  cmd = 'git diff',
  direction = 'float',
  close_on_exit = true,
  hidden = true,
}

return function() git_diff:open() end
