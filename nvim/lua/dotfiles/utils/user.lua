---@module "lazy.types"
---
---@class dotfiles.utils.User
---@field extra? LazySpec[]
---@field lang? string[]
---@field ui? { blend: integer, colorscheme: string }
---@field nightly? boolean|integer
local M = {
  extra = {},
  lang = {},
  ui = {
    blend = 10,
    colorscheme = "tokyonight",
  },
  nightly = false,
}

local PATH = vim.fs.joinpath(vim.fn.stdpath("data"), "nvim.user")

if vim.fn.filereadable(PATH) == 1 then
  M = vim.tbl_deep_extend("force", M, dofile(PATH))
end

return M
