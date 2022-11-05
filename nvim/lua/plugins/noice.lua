return function()
  require('noice').setup {
    popupmenu = { backend = 'cmp' },
    lsp = { signature = { enabled = false } },
    routes = {
      { view = 'split', filter = { event = 'msg_show', min_height = 5 } },
    },
    views = {
      split = { enter = true },
    },
  }
end
