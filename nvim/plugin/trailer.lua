local match_group = "DotfilesTrailer"

local function get_match_id()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == match_group then
      return match.id
    end
  end
end

local function unhighlight() pcall(vim.fn.matchdelete, get_match_id()) end

local function highlight()
  if vim.fn.mode() ~= "n" then
    unhighlight()
    return
  end
  if get_match_id() then
    return
  end
  if vim.bo.buftype ~= "" then
    return
  end
  vim.fn.matchadd(match_group, [[\s\+$]])
end

local augroup = vim.api.nvim_create_augroup("dotfiles_trailer_autocmds", {})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
  callback = highlight,
  group = augroup,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
  callback = unhighlight,
  group = augroup,
})
vim.api.nvim_create_autocmd("OptionSet", {
  callback = function()
    if vim.v.option_new == "" then
      highlight()
    else
      unhighlight()
    end
  end,
  group = augroup,
  pattern = "buftype",
})

vim.api.nvim_set_hl(0, match_group, { bg = "LightGreen" })

vim.defer_fn(highlight, 0)

vim.api.nvim_create_user_command("TrailSpace", function()
  local curpos = vim.api.nvim_win_get_cursor(0)
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, curpos)
end, {})
