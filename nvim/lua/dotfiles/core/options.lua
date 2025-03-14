vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.opt.autowrite = true
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
vim.opt.colorcolumn = "80"
vim.opt.completeopt = "menu,menuone,popup,fuzzy"
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.diffopt:append("vertical")
vim.opt.diffopt:remove("linematch:40")
vim.opt.expandtab = true
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "gb2312", "gb18030", "gbk", "ucs-bom", "cp936", "latin1" }
vim.opt.fillchars = { eob = " ", fold = " ", foldclose = "", foldopen = "", foldsep = " " }
vim.opt.foldenable = false
vim.opt.foldexpr = "v:lua.require'dotfiles.utils.ui'.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldtext = ""
vim.opt.formatoptions = "jcroqlnt"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.helpheight = 10
vim.opt.ignorecase = true
vim.opt.indentkeys:remove(":")
vim.opt.jumpoptions = "view"
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { extends = "…", nbsp = "␣", precedes = "…", tab = "→ " }
vim.opt.number = true
vim.opt.pumblend = Dotfiles.user.ui.blend
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
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 200
vim.opt.virtualedit = "block"
vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 5
vim.opt.wrap = false
