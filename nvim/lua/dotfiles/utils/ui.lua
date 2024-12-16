local M = {}

M.icons = {
  -- clangd_extensions.nvim {{{
  ast = {
    role_icons = {
      type = "",
      declaration = "",
      expression = "",
      specifier = "",
      statement = "",
      ["template argument"] = "",
    },
    kind_icons = {
      Compound = "",
      Recovery = "",
      TranslationUnit = "",
      PackExpansion = "",
      TemplateTypeParm = "",
      TemplateTemplateParm = "",
      TemplateParamObject = "",
    },
  },
  -- }}}
  diagnostic = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = "",
  },
}

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
