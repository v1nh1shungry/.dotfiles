---@module "lazy.types"
---
---@class dotfiles.user.Config
---@field extra LazySpec[]
---@field ui { blend: integer, colorscheme: string }
---@field task { compile: table<string, string[]>, execute: table<string, string[]> }
---@field nightly boolean|integer
local M = {
  extra = {},
  ui = {
    blend = 10,
    colorscheme = "tokyonight",
  },
  task = {
    compile = {},
    execute = {},
  },
  nightly = false,
}

local NVIMRC = vim.fs.joinpath(vim.env.HOME, ".nvimrc")
if vim.fn.filereadable(NVIMRC) == 1 then
  M = vim.tbl_deep_extend("force", M, dofile(NVIMRC))
end

return M
