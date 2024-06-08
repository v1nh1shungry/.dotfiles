if not vim.g.vscode then
  return {}
end

local enabled = {}
for _, module in ipairs({ "core" }) do
  vim.list_extend(enabled, vim.tbl_map(function(spec) return spec[1] end, require("dotfiles.plugins." .. module)))
end

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin) return vim.list_contains(enabled, plugin[1]) end

local vscode = require("vscode")
vim.notify = vscode.notify

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
