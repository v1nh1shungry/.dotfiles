Dotfiles.map({ "<Leader>cf", "<Cmd>%! jq .<CR>", buffer = true, desc = "Format" })
Dotfiles.map({ "<Leader>cF", "<Cmd>%! jq --compact-output .<CR>", buffer = true, desc = "Format (Compact)" })
Dotfiles.map({
  "o",
  function()
    if vim.api.nvim_get_current_line():find("[^,{[]$") then
      return "A,<CR>"
    end
    return "o"
  end,
  desc = "New Line Below",
  expr = true,
})
