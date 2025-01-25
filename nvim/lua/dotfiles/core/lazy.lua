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
  checker = { enabled = true },
  spec = vim.list_extend(
    { { import = "dotfiles.plugins" } },
    vim
      .iter(require("dotfiles.user").extra)
      :map(function(m)
        if type(m) == "string" and vim.F.npcall(require, "dotfiles.plugins.extra." .. m) then
          return { import = "dotfiles.plugins.extra." .. m }
        end
        return m
      end)
      :totable()
  ),
  local_spec = false,
  install = { colorscheme = { require("dotfiles.user").ui.colorscheme } },
  dev = {
    path = vim.fs.joinpath(vim.env.HOME, "Documents", "repos"),
    patterns = { "v1nh1shungry" },
    fallback = true,
  },
  diff = { cmd = "diffview.nvim" },
  performance = {
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
})
