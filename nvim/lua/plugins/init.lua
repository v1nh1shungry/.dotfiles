-- Disable builtin plugins
vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
vim.g.loaded_syntax_completion = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_sql_completion = 1
vim.g.loaded_remote_plugins = 1

-- Bootstrap packer.nvim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    Basic Enhancement                     │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'andymass/vim-matchup',
    config = function() vim.cmd [[let g:matchup_matchparen_offscreen = { 'method': '' }]] end,
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'tpope/vim-unimpaired',
    keys = {
      { 'n', '[' },
      { 'n', ']' },
    },
  }
  use { 'tpope/vim-sleuth', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'wellle/targets.vim', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'lewis6991/impatient.nvim', config = function() require('impatient').enable_profile() end }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = require('plugins.nvim-treesitter'),
    event = { 'BufNewFile', 'BufReadPost' },
    requires = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', opt = true },
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function() require('treesitter-context').setup() end,
        opt = true,
      },
      { 'nvim-treesitter/playground', opt = true },
    },
    run = ':TSUpdate',
  }
  use {
    'abecodes/tabout.nvim',
    after = 'nvim-cmp',
    config = require('plugins.tabout'),
    requires = 'nvim-treesitter',
  }
  use {
    'ethanholz/nvim-lastplace',
    config = function() require 'nvim-lastplace'.setup() end,
    event = { 'BufNewFile', 'BufReadPost' },
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                     Edit Enhancement                     │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'ntpeters/vim-better-whitespace',
    config = require('plugins.vim-better-whitespace'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = require('plugins.indent-blankline'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end,
    keys = {
      { 'n', 'gc' },
      { 'v', 'gc' },
    },
  }
  use {
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = require('plugins.nvim-autopairs'),
  }
  use {
    'kylechui/nvim-surround',
    config = function() require('nvim-surround').setup() end,
    keys = {
      { 'n', 'ys' },
      { 'n', 'yS' },
      { 'n', 'cs' },
      { 'n', 'cS' },
      { 'n', 'ds' },
      { 'n', 'dS' },
      { 'x', 's' },
      { 'x', 'S' },
    },
  }
  use {
    'tversteeg/registers.nvim',
    config = function() require('registers').setup() end,
    keys = {
      { 'n', '"' },
      { 'i', '<C-r>' },
    },
  }
  use {
    'AndrewRadev/splitjoin.vim',
    config = function() vim.g.splitjoin_quiet = 1 end,
    keys = {
      { 'n', 'gS' },
      { 'n', 'gJ' },
    },
  }
  use { 'mg979/vim-visual-multi', event = { 'BufNewFile', 'BufReadPost' } }
  use { 'LudoPinelli/comment-box.nvim', cmd = 'CBcbox' }
  use {
    'vim-scripts/ReplaceWithRegister',
    keys = { { 'n', 'gr' } },
  }
  use {
    'tommcdo/vim-exchange',
    keys = {
      { 'n', 'cx' },
      { 'v', 'X' },
    },
  }
  use {
    'monaqa/dial.nvim',
    config = require('plugins.dial'),
    keys = {
      { 'n', '<C-a>' },
      { 'n', '<C-x>' },
    },
  }
  use {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModeToggle',
    config = function() vim.g.table_mode_corner = '|' end,
    keys = { { 'n', '<Leader>tm' } },
  }
  use {
    'kkoomen/vim-doge',
    cmd = 'DogeGenerate',
    config = function() vim.g.doge_enable_mappings = false end,
    run = ':call doge#install()',
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       Intellisense                       │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'hrsh7th/nvim-cmp',
    config = require('plugins.nvim-cmp'),
    event = { 'CmdlineEnter', 'InsertEnter' },
    requires = {
      {
        'L3MON4D3/LuaSnip',
        opt = true,
        requires = { { 'rafamadriz/friendly-snippets', opt = true } },
      },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
      { 'onsails/lspkind.nvim', opt = true },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' },
    },
  }
  use {
    'neovim/nvim-lspconfig',
    config = function() require('plugins.lspconfig') end,
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      {
        'glepnir/lspsaga.nvim',
        event = 'LspAttach',
        config = require('plugins.lspsaga'),
      },
      'folke/neodev.nvim',
      'p00f/clangd_extensions.nvim',
      'b0o/schemastore.nvim',
    },
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = require('plugins.null-ls'),
    requires = 'nvim-lua/plenary.nvim',
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          Debug                           │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'mfussenegger/nvim-dap',
    config = require('plugins.nvim-dap'),
    keys = {
      { 'n', '<F9>' },
      { 'n', '<F5>' },
    },
    requires = {
      { 'rcarriga/nvim-dap-ui', opt = true },
      {
        'theHamsta/nvim-dap-virtual-text',
        opt = true,
        requires = 'nvim-treesitter/nvim-treesitter',
      },
    },
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                            UI                            │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'RRethy/vim-illuminate',
    config = function() require('illuminate').configure { providers = { 'lsp', 'treesitter' } } end,
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use { 'machakann/vim-highlightedyank', event = 'TextYankPost' }
  use { 'romainl/vim-cool', event = 'CmdlineEnter' }
  use {
    'akinsho/toggleterm.nvim',
    config = function() require('toggleterm').setup { open_mapping = '<M-=>', size = 10 } end,
    keys = { { 'n', '<M-=>' } }
  }
  use { 'folke/trouble.nvim', cmd = { 'TroubleToggle', 'TroubleRefresh', 'TodoTrouble' } }
  use { 'skywind3000/vim-quickui', config = require('plugins.vim-quickui') }
  use {
    'akinsho/bufferline.nvim',
    config = require('plugins.bufferline'),
    event = { 'BufNewFile', 'BufReadPost' },
    requires = 'nvim-tree/nvim-web-devicons',
  }
  use {
    'folke/todo-comments.nvim',
    config = function() require('todo-comments').setup { signs = false } end,
    event = { 'BufNewFile', 'BufReadPost' },
    requires = 'nvim-lua/plenary.nvim',
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end,
    event = { 'BufReadPost', 'BufNewFile' },
  }
  use {
    'windwp/windline.nvim',
    config = require('plugins.windline'),
    event = { 'BufNewFile', 'BufReadPost' },
  }
  use {
    'goolord/alpha-nvim',
    config = require('plugins.alpha-nvim'),
    requires = 'nvim-tree/nvim-web-devicons',
  }
  use {
    'folke/noice.nvim',
    config = require('plugins.noice'),
    requires = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
  }
  use {
    'preservim/vim-pencil',
    config = require('plugins.vim-pencil'),
    ft = 'markdown',
  }
  use {
    'https://gitlab.com/yorickpeterse/nvim-pqf',
    after = 'asyncrun.vim',
    config = function() require('pqf').setup() end,
  }
  use {
    'gorbit99/codewindow.nvim',
    config = require('plugins.codewindow'),
    keys = {
      { 'n', '<Leader>mo' },
      { 'n', '<Leader>mm' },
    },
  }
  use {
    'nvim-neo-tree/neo-tree.nvim',
    config = require('plugins.neo-tree'),
    keys = { { 'n', '<Leader>e' } },
    requires = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          Tools                           │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'brooth/far.vim',
    cmd = { 'Farf', 'Farr' },
    config = function() vim.g.enable_undo = true end,
  }
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }
  use { 'metakirby5/codi.vim', cmd = 'Codi!!' }
  use {
    'rhysd/clever-f.vim',
    config = require('plugins.clever-f'),
    keys = {
      { 'n', 'f' },
      { 'n', 'F' },
      { 'v', 'f' },
      { 'v', 'F' },
    },
  }
  use {
    'williamboman/mason.nvim',
    config = require('plugins.mason'),
    requires = { 'williamboman/mason-lspconfig.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  }
  use {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    config = require('plugins.telescope'),
    keys = {
      { 'n', '<Leader>h' },
      { 'n', '<C-p>' },
    },
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-file-browser.nvim', opt = true },
    },
  }
  use { 'lambdalisue/suda.vim', cmd = { 'SudoRead', 'SudoWrite' } }
  use {
    'krady21/compiler-explorer.nvim',
    cmd = { 'CECompile', 'CECompileLive' },
    config = function() vim.cmd [[packadd dressing.nvim]] end,
    requires = { { 'stevearc/dressing.nvim', opt = true } },
  }
  use {
    'skywind3000/asynctasks.vim',
    cmd = { 'AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit' },
    config = require('plugins.asynctasks'),
    keys = {
      { 'n', '<Leader>fb' },
      { 'n', '<Leader>fr' },
    },
    requires = { { 'skywind3000/asyncrun.vim', cmd = { 'AsyncRun', 'AsyncStop' } } },
  }
  use { 'skywind3000/vim-cppman', cmd = 'Cppman' }
  use { 'tpope/vim-fugitive', cmd = { 'Gvdiffsplit' } }
  use {
    'iamcco/markdown-preview.nvim',
    cmd = 'MarkdownPreview',
    run = function() vim.fn['mkdp#util#install']() end,
  }
  use {
    'jbyuki/venn.nvim',
    cmd = 'VBox',
    config = function() vim.cmd [[setlocal ve=all]] end,
  }
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          Themes                          │
  --  ╰──────────────────────────────────────────────────────────╯
  use {
    'rebelot/kanagawa.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'kanagawa' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'wuelnerdotexe/vim-enfocado',
    cond = function() return require('plugins.colorscheme').colorscheme == 'enfocado' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'folke/tokyonight.nvim',
    cond = function() return string.find(require('plugins.colorscheme').colorscheme, 'tokyonight') ~= nil end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'EdenEast/nightfox.nvim',
    cond = function() return string.find(require('plugins.colorscheme').colorscheme, 'fox') ~= nil end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'shaunsingh/nord.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'nord' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'Mofiqul/dracula.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'dracula' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'projekt0n/github-nvim-theme',
    cond = function() return string.find(require('plugins.colorscheme').colorscheme, 'github') ~= nil end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'rose-pine/neovim',
    as = 'rose-pine',
    cond = function() return require('plugins.colorscheme').colorscheme == 'rose-pine' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    cond = function() return string.find(require('plugins.colorscheme').colorscheme, 'catppuccin') ~= nil end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'marko-cerovac/material.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'material' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'glepnir/zephyr-nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'zephyr' end,
    config = function() require('plugins.colorscheme').setup() end,
  }
  use {
    'lunarvim/darkplus.nvim',
    cond = function() return require('plugins.colorscheme').colorscheme == 'darkplus' end,
    config = function() require('plugins.colorscheme').setup() end,
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
