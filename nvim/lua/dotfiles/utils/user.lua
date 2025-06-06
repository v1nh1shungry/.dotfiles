---@module "lazy.types"
---
---@class dotfiles.utils.User
---@field colorscheme? string
---@field extra? LazySpec[]
---@field lang? string[]
---@field nightly? boolean|integer
local M = {
  colorscheme = "tokyonight",
  extra = {},
  lang = {},
  nightly = false,
}

local PATH = vim.fs.joinpath(vim.fn.stdpath("data"), "nvim.user")

if vim.fn.filereadable(PATH) == 1 then
  M = vim.tbl_deep_extend("force", M, dofile(PATH))
end

return M
