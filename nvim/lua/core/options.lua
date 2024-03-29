vim.opt.background = require('user').ui.background
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = '80'
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1'
vim.opt.fillchars = { eob = ' ', fold = ' ', foldclose = '', foldopen = '', foldsep = ' ' }
vim.opt.foldenable = false
vim.opt.formatoptions = 'jcroqlnt'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.helpheight = 10
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.laststatus = 0
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { extends = '…', nbsp = '␣', precedes = '…', tab = '»·' }
vim.opt.mousemoveevent = true
vim.opt.number = true
vim.opt.pumblend = require('user').ui.blend
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.scrolloff = 5
vim.opt.shell = '/bin/fish'
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append({ C = true, I = true, W = true, c = true })
vim.opt.showcmdloc = 'statusline'
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitkeep = 'screen'
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.updatetime = 200
vim.opt.virtualedit = 'block'
vim.opt.wildignorecase = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.winblend = require('user').ui.blend
vim.opt.winminwidth = 5
vim.opt.wrap = false
vim.opt.writebackup = false
