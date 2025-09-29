Dotfiles.map({
  "o",
  function()
    if vim.api.nvim_get_current_line():find("[^,{[]$") then
      return "A,<CR>"
    end
    return "o"
  end,
  buffer = true,
  desc = "New Line Below",
  expr = true,
})
