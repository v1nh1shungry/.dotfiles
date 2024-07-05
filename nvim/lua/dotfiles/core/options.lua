if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end

vim.opt.autowrite = true
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "80"
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1"
vim.opt.fillchars = { eob = " ", fold = " ", foldclose = "", foldopen = "", foldsep = " " }
vim.opt.foldcolumn = "auto"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.formatoptions = "jcroqlnt"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.helpheight = 10
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.jumpoptions = { "stack", "view" }
vim.opt.laststatus = 0
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { extends = "…", nbsp = "␣", precedes = "…", tab = "→ " }
vim.opt.mousemoveevent = true
vim.opt.number = true
vim.opt.pumblend = require("dotfiles.user").ui.blend
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 5
vim.opt.sessionoptions = { "buffers", "curdir", "folds", "globals", "help", "skiprtp", "tabpages", "winsize" }
vim.opt.shell = "/bin/fish"
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append({ C = true, I = true, W = true, c = true })
vim.opt.showcmdloc = "statusline"
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.softtabstop = 2
vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 200
vim.opt.virtualedit = "block"
vim.opt.winblend = require("dotfiles.user").ui.blend
vim.opt.winminwidth = 5
vim.opt.wrap = false
vim.opt.writebackup = false