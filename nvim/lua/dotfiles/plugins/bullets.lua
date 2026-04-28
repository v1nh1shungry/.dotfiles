return {
  {
    "bullets-vim/bullets.vim",
    config = function()
      vim.g.bullets_checkbox_markers = " X"
      vim.g.bullets_enabled_file_types = { "markdown" }
      vim.g.bullets_set_mappings = false
    end,
    keys = {
      { "<CR>", "<Plug>(bullets-newline)", desc = "New Line", ft = "markdown", mode = "i" },
      { "o", "<Plug>(bullets-newline)", desc = "New Line", ft = "markdown" },
      { "<CR>", "<Plug>(bullets-toggle-checkbox)", desc = "Toggle Checkbox", ft = "markdown" },
      { "<C-t>", "<Plug>(bullets-demote)", desc = "Demote", ft = "markdown", mode = "i" },
      { ">>", "<Plug>(bullets-demote)", desc = "Demote", ft = "markdown" },
      { ">", "<Plug>(bullets-demote)", desc = "Demote", ft = "markdown", mode = "x" },
      { "<C-d>", "<Plug>(bullets-promote)", desc = "Promote", ft = "markdown", mode = "i" },
      { "<<", "<Plug>(bullets-promote)", desc = "Promote", ft = "markdown" },
      { "<", "<Plug>(bullets-promote)", desc = "Promote", ft = "markdown", mode = "x" },
      { "gN", "<Plug>(bullets-renumber)", desc = "Renumber", ft = "markdown", mode = { "n", "x" } },
    },
    ft = "markdown",
  },
}
