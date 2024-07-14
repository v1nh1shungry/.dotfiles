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

require("lazy").setup({
  spec = vim.list_extend(
    { { import = "dotfiles.plugins" } },
    vim
      .iter(require("dotfiles.user").plugins.extra)
      :map(function(m) return { import = "dotfiles.plugins.extra." .. m } end)
      :totable()
  ),
  install = { colorscheme = { require("dotfiles.user").ui.colorscheme } },
  checker = { enabled = true },
  dev = { path = "~/repos" },
  performance = {
    rtp = {
      disabled_plugins = {
        "editorconfig",
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "osc52",
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
})
