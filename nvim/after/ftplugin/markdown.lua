vim.opt_local.wrap = true
vim.opt_local.conceallevel = 2

-- Copy from https://github.com/chrisgrieser/.config {{{
-- Insert bullets automatically.
do
  vim.opt_local.formatoptions:append("r")
  vim.opt_local.formatoptions:append("o")

  local function bullet(key)
    local old_comments = vim.opt_local.comments:get()
    vim.opt_local.comments = {
      "b:- [ ]",
      "b:- [x]",
      "b:*",
      "b:-",
      "b:+",
      "b:\t*",
      "b:\t-",
      "b:\t+",
      "b:1.",
      "b:\t1.",
      "n:>",
    }
    vim.defer_fn(function() vim.opt_local.comments = old_comments end, 1)
    return key
  end

  Dotfiles.map({ "o", function() return bullet("o") end, buffer = true, desc = "New Line Below", expr = true })
  Dotfiles.map({
    "<CR>",
    function() return bullet("<CR>") end,
    buffer = true,
    desc = "Begin New Line",
    expr = true,
    mode = "i",
  })
end
-- }}}
