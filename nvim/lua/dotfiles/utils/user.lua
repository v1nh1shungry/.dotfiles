---@module "lazy.types"
---
---@class dotfiles.utils.User
---@field extra? LazySpec[]
---@field ui? { blend: integer, colorscheme: string }
---@field nightly? boolean|integer
local M = {
  extra = {},
  ui = {
    blend = 10,
    colorscheme = "tokyonight",
  },
  nightly = false,
}

M.PATH = vim.fs.joinpath(vim.fn.stdpath("data"), "nvim.user")

if vim.fn.filereadable(M.PATH) == 1 then M = vim.tbl_deep_extend("force", M, dofile(M.PATH)) end

return M
