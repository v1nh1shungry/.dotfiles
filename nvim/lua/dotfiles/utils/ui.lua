---@class dotfiles.utils.UI
local M = {}

M.icons = setmetatable({
  diagnostics = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = "",
  },
}, {
  __index = function(_, category)
    return setmetatable({}, {
      __index = function(_, name)
        return require("mini.icons").get(category, name)
      end,
    })
  end,
})

-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/ui.lua {{{
local skip_foldexpr = {}
local skip_check = assert(vim.uv.new_check())

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  if skip_foldexpr[buf] then
    return "0"
  end

  if vim.bo[buf].buftype ~= "" then
    return "0"
  end

  if vim.bo[buf].filetype == "" then
    return "0"
  end

  if pcall(vim.treesitter.get_parser, buf) then
    return vim.treesitter.foldexpr()
  end

  skip_foldexpr[buf] = true
  skip_check:start(function()
    skip_foldexpr = {}
    skip_check:stop()
  end)

  return "0"
end
-- }}}

return M
