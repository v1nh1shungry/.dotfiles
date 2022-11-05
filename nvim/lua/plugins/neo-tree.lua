return function()
  require('neo-tree').setup {
    close_if_last_window = true,
    source_selector = { winbar = true },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          '.git',
          'node_modules',
          '.DS_Store',
        },
      },
      hijack_netrw_behavior = 'disabled',
    },
    window = {
      mappings = {
        ['l'] = 'open',
        ['h'] = 'close_node',
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(_) require("neo-tree").close_all() end
      },
    },
  }
end
