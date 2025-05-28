local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- https://github.com/LazyVim/LazyVim {{{
local Event = require("lazy.core.handler.event")
Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
Event.mappings["User LazyFile"] = Event.mappings.LazyFile
-- }}}

require("lazy").setup("dotfiles.plugins", {
  checker = { enabled = true },
  dev = {
    fallback = true,
    path = vim.fs.joinpath(vim.env.HOME, "Documents", "repos"),
    patterns = { "v1nh1shungry" },
  },
  diff = { cmd = "diffview.nvim" },
  install = { colorscheme = { Dotfiles.user.ui.colorscheme } },
  local_spec = false,
  performance = {
    reset_packpath = false,
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "rplugin",
        "shada",
        "spellfile",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  rocks = { enabled = false },
})

-- TODO: may be overkilled
vim.api.nvim_create_autocmd("User", {
  callback = function()
    for pack, _ in vim.fs.dir(vim.fs.joinpath(vim.fn.stdpath("config"), "pack", "dotfiles", "opt")) do
      vim.cmd("packadd " .. pack)
    end
  end,
  group = Dotfiles.augroup("pack"),
  once = true,
  pattern = "VeryLazy",
})
