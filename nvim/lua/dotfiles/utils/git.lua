---@class dotfiles.utils.Git
local M = {}

-- https://github.com/chrisgrieser/nvim-tinygit/blob/main/lua/tinygit/statusline/branch-state.lua {{{
local function git_branch_state()
  local cwd = vim.fn.getcwd()
  if not cwd then
    return ""
  end

  local allBranchInfo = vim.system({ "git", "-C", cwd, "branch", "--verbose" }):wait()
  if allBranchInfo.code ~= 0 then
    return ""
  end

  local branches = vim.split(allBranchInfo.stdout, "\n")
  local currentBranchInfo

  for _, line in pairs(branches) do
    currentBranchInfo = line:match("^%* .*")
    if currentBranchInfo then
      break
    end
  end

  if not currentBranchInfo then
    return ""
  end

  local ahead = currentBranchInfo:match("ahead (%d+)")
  local behind = currentBranchInfo:match("behind (%d+)")

  if ahead and behind then
    return ("󰃻" .. " %s/%s"):format(ahead, behind)
  elseif ahead then
    return "󰶣" .. ahead
  elseif behind then
    return "󰶡" .. behind
  end

  return ""
end

function M.refresh_branch_state()
  vim.b.dotfiles_git_branch_state = git_branch_state()
end

vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged", "FocusGained" }, {
  callback = M.refresh_branch_state,
  group = Dotfiles.augroup("lualine_git_branch_state"),
})
-- }}}

return M
