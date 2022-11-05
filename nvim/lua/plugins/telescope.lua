return function()
  local telescope = require('telescope')

  vim.cmd [[packadd telescope-file-browser.nvim]]

  telescope.setup {
    extensions = {
      file_browser = {
        hidden = true,
        hijack_netrw = true,
      },
    },
  }

  telescope.load_extension 'file_browser'
  telescope.load_extension 'noice'
end
