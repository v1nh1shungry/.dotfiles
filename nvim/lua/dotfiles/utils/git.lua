---@class dotfiles.utils.Git
local M = {}

---@return string?
function M.root() return vim.fs.root(vim.fn.getcwd(), ".git") end

return M
