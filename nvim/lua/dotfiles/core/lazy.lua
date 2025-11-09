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

-- https://github.com/folke/lazy.nvim/issues/1951#issuecomment-2860253949
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args) vim.api.nvim_win_set_config(vim.fn.win_findbuf(args.buf)[1], { border = "none" }) end,
  desc = "Respect `winborder` in lazy.nvim's backdrop window",
  group = Dotfiles.augroup("core.lazy.backdrop-border"),
  pattern = "lazy_backdrop",
})

require("lazy").setup(
  vim.list_extend(
    {
      { import = "dotfiles.plugins" },
    },
    vim
      .iter(Dotfiles.user.extra)
      :map(function(spec)
        if type(spec) == "string" and vim.F.npcall(require, "dotfiles.plugins.extra." .. spec) then
          return { import = "dotfiles.plugins.extra." .. spec }
        end
        return spec
      end)
      :totable()
  ),
  {
    checker = {
      enabled = true,
    },
    dev = {
      fallback = true,
      path = vim.fs.joinpath(vim.uv.os_homedir(), "Documents", "repos"),
      patterns = { "v1nh1shungry" },
    },
    diff = {
      cmd = "diffview.nvim",
    },
    install = {
      colorscheme = { Dotfiles.user.colorscheme },
    },
    local_spec = false,
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "net",
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
    rocks = {
      enabled = false,
    },
  }
)
