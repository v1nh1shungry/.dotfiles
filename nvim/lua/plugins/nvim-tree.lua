local status_ok, tree = pcall(require, 'nvim-tree')
if not status_ok then
  return
end

tree.setup {
  view = {
    mappings = {
      list = {
        { key = 'l', action = 'edit' },
        { key = 'h', action = 'close_node' },
      }
    }
  },
  actions = {
    open_file = {
      quit_on_open = true
    }
  }
}

require('utils.keymaps').nnoremap('<Leader>e', ':NvimTreeToggle<CR>')
