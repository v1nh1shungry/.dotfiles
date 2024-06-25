local specs = {
  {
    "glacambre/firenvim",
    lazy = not vim.g.started_by_firenvim,
    build = function() vim.fn["firenvim#install"](0) end,
  },
}

if not vim.g.started_by_firenvim then
  return specs
end

local enabled = vim.tbl_map(function(spec) return spec[1] end, specs)
for _, module in ipairs({ "core", "themes" }) do
  vim.list_extend(enabled, vim.tbl_map(function(spec) return spec[1] end, require("dotfiles.plugins." .. module)))
end

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin) return vim.list_contains(enabled, plugin[1]) end

vim.g.firenvim_config = {
  localSettings = {
    [".*"] = {
      cmdline = "neovim",
      takeover = "never",
    },
  },
}

local map = require("dotfiles.utils.keymap")
map({ "<C-z>", "<Cmd>call firenvim#hide_frame()<CR>", desc = "Hide neovim frame" })
map({ "<Esc><Esc>", "<Cmd>call firenvim#focus_page()<CR>", desc = "Back to the page" })

return specs
