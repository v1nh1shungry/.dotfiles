---@class dotfiles.utils.Treesitter
local M = {}

local ts_group = Dotfiles.augroup("utils.treesitter.on-available")

---@param callback fun(buffer: integer)
function M.on_available(callback)
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      -- Source: https://github.com/MeanderingProgrammer/treesitter-modules.nvim {{{
      -- Author: MeanderingProgrammer
      -- License: Apache-2.0
      local lang = vim.treesitter.language.get_lang(args.match) or args.match
      if not vim.treesitter.language.add(lang) then
        return
      end
      -- }}}

      callback(args.buf)
    end,
    desc = "Excute callback when tree-sitter is available for a filetype",
    group = ts_group,
  })
end

return M
