---@class dotfiles.utils.User
---@field colorscheme string
---@field env table<string, string|integer>
---@field extra LazySpec[]
local M = {
  colorscheme = "tokyonight",
  env = {},
  extra = {},
}

vim.filetype.add({
  filename = {
    ["nvim.user"] = "lua",
  },
})

local path = vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "nvim.user")

if vim.fn.filereadable(path) == 1 then
  M = vim.tbl_deep_extend("force", M, dofile(path) --[[@as dotfiles.utils.User]])
end

return M
