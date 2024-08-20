-- https://www.lazyvim.org/extras/vscode {{{
if not vim.g.vscode then
  return {}
end

local enabled = {}
for _, module in ipairs({ "core", "editor", "themes" }) do
  vim.list_extend(enabled, vim.tbl_map(function(spec) return spec[1] end, require("dotfiles.plugins." .. module)))
end

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin) return vim.list_contains(enabled, plugin[1]) end

local vscode = require("vscode")
vim.notify = vscode.notify

local map = require("dotfiles.utils.keymap")
map({ "]b", "<Cmd>Tabnext<CR>", desc = "Go to the next buffer" })
map({ "]B", "<Cmd>Tabfirst<CR>", desc = "Go to the first buffer" })
map({ "[b", "<Cmd>Tabprevious<CR>", desc = "Go to the previous buffer" })
map({ "[B", "<Cmd>Tablast<CR>", desc = "Go to the last buffer" })

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
-- }}}
