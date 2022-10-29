return function()
  local telescope = require('telescope')

  vim.cmd [[packadd telescope-file-browser.nvim]]

  telescope.setup {
    pickers = {
      colorscheme = { enable_preview = true },
    },
    extensions = {
      file_browser = {
        hidden = true,
        hijack_netrw = true,
      },
    },
  }

  telescope.load_extension 'file_browser'
  telescope.load_extension 'notify'
end
